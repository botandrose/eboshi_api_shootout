{-# LANGUAGE OverloadedStrings #-}

import Client
import DBConfig
import Control.Monad
import Control.Monad.IO.Class
import Database.MySQL.Simple
import Web.Scotty

-- | Fetch a client from MySQL.
fetchClients :: IO [Client]
fetchClients = do
  DBConfig user pass database <- readDBConfig
  conn <- connect defaultConnectInfo {
            connectUser = user,
            connectPassword = pass,
            connectDatabase = database }
  results <- query_ conn "SELECT id, name, address, city, state, zip, country, email, contact, phone, created_at, updated_at FROM clients LIMIT 1"
  clients <- forM results $ \(id, name, address, city, state, zip, country, email, contact, phone, created_at, updated_at) ->
    return $ Client id name address city state zip country email contact phone created_at updated_at
  return clients

-- | Generate a simple test page.
testPage :: ActionM ()
testPage = html "Hello world"

-- | Respond to an API "clients" request with JSON.
clientsPage :: ActionM ()
clientsPage = do
  clients <- liftIO fetchClients
  json $ head clients

-- | Provide the top-level API.
main :: IO ()
main = scotty 6969 $ do
  get "/api/test" testPage
  get "/api/clients" clientsPage


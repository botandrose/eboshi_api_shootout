{-# LANGUAGE OverloadedStrings #-}

import Client
import DBConfig

import Control.Monad
import Control.Monad.IO.Class
import Data.Word
import Database.MySQL.Simple
import Web.Scotty

-- | Fetch a client ID from MySQL.
fetchId :: IO Word64
fetchId = do
  DBConfig user pass database <- readDBConfig
  conn <- connect defaultConnectInfo {
            connectUser = user,
            connectPassword = pass,
            connectDatabase = database }
  [Only result] <- query_ conn "SELECT 1"
  return result

-- | Generate a simple test page.
testPage :: ActionM ()
testPage = html "Hello world"

-- | Respond to an API "clients" request with JSON.
clientsPage :: ActionM ()
clientsPage = do
  clientId <- liftIO fetchId
  json Client {
    Client.id=show clientId,
    name="Bot and Rose Design",
    address="625 NW Everett St",
    city="Portland",
    state="OR",
    Client.zip="97209",
    country="USA",
    email="info@botandrose.com",
    contact="Michael Gubitosa",
    phone="(503) 662-2712",
    created_at="2006-06-25T14:08:31Z",
    updated_at="2015-08-29T09:58:23Z"
  }

-- | Provide the top-level API.
main :: IO ()
main = scotty 6969 $ do
  get "/api/test" testPage
  get "/api/clients" clientsPage


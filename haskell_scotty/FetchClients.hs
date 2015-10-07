{-# LANGUAGE OverloadedStrings #-}
module FetchClients where

import Client
import DBConfig
import Database.MySQL.Simple
import Control.Monad

-- | Fetch a client from MySQL.
fetchClients :: IO [Client]
fetchClients = do
  DBConfig user pass database <- readDBConfig
  conn <- connect defaultConnectInfo {
            connectUser = user,
            connectPassword = pass,
            connectDatabase = database }
  results <- query_ conn "SELECT * FROM clients"
  clients <- forM results $ \(id, name, address, city, state, zip, country, email, contact, phone, created_at, updated_at) ->
    return $ Client id name address city state zip country email contact phone created_at updated_at
  return clients

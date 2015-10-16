{-# LANGUAGE OverloadedStrings #-}

module ClientRepo (getClients) where

import Client
import ConstructResult
import DBConnection
import Database.MySQL.Simple
import Database.MySQL.Simple.QueryResults

getClients :: IO [Client]
getClients = do
  conn <- connectDB
  clients <- query_ conn "SELECT * FROM clients"
  return clients

instance QueryResults Client where
  convertResults fs vs = Client $... (Prelude.zip fs vs)

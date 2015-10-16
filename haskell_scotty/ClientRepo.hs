{-# LANGUAGE OverloadedStrings #-}

module ClientRepo(ClientRepo.all) where

import Client
import ConstructResult
import DBConnection
import Database.MySQL.Simple
import Database.MySQL.Simple.QueryResults

all :: IO [Client]
all = do
  conn <- DBConnection.connect
  clients <- query_ conn "SELECT * FROM clients"
  return clients

instance QueryResults Client where
  convertResults fs vs = Client $... (Prelude.zip fs vs)

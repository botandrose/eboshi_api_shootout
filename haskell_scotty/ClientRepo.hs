{-# LANGUAGE OverloadedStrings #-}

module ClientRepo (getClients, saveClient) where

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

saveClient :: Client -> IO Client
saveClient client = do
  -- conn <- connectDB
  -- results <- query_ conn "INSERT INTO clients SET \
  --         \name=\"Bot and Rose Design\", \
  --         \address=\"625 NW Everett St\", \
  --         \city=\"Portland\", \
  --         \state=\"OR\", \
  --         \zip=\"97209\", \
  --         \country=\"USA\", \
  --         \email=\"info@botandrose.com\", \
  --         \contact=\"Michael Gubitosa\", \
  --         \phone=\"(503) 662-2712\", \
  --         \created_at=\"2006-06-25T14:08:31\", \
  --         \updated_at=\"2015-08-29T09:58:23\";"
  --
  return client { Client.id = (1 :: Int) }

instance QueryResults Client where
  convertResults fs vs =
      Client $... constructorWrap (undefined :: Client) fs vs

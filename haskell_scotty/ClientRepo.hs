{-# LANGUAGE OverloadedStrings #-}

module ClientRepo (getClients, saveClient, deleteClient) where

import Client
import DBConnection
import Database.MySQL.Simple

getClients :: IO [Client]
getClients = do
  conn <- connectDB
  clients <- query_ conn "SELECT * FROM clients"
  return clients

saveClient :: Client -> IO Client
saveClient client = do
  conn <- connectDB
  _ <- execute conn "INSERT INTO clients \
    \(name,address,city,state,zip,country,email,contact,phone,created_at,updated_at) values \
    \(?,?,?,?,?,?,?,?,?,?,?)" client
  results <- query_ conn "SELECT LAST_INSERT_ID()"
  let [Only clientId] = results
  return client { Client.id = clientId }

deleteClient :: Int -> IO ()
deleteClient clientId = do
  conn <- connectDB
  _ <- execute conn "DELETE FROM clients WHERE id=?" [clientId]
  return ()

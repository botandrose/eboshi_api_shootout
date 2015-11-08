{-# LANGUAGE OverloadedStrings #-}

module AccountRepo (saveAccount) where

import Account
import DBConnection
import Database.MySQL.Simple

saveAccount :: Account -> IO Account
saveAccount account = do
  conn <- connectDB
  _ <- execute conn "INSERT INTO users \
    \(name,email,created_at,updated_at) values \
    \(?,?,?,?)" account
  results <- query_ conn "SELECT LAST_INSERT_ID()"
  let [Only accountId] = results
  return account { Account.id = accountId }


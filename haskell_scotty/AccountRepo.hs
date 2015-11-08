{-# LANGUAGE OverloadedStrings #-}

module AccountRepo (saveAccount, findAccount) where

import Account
import DBConnection
import Database.MySQL.Simple
import Encryption
import Data.Time.Clock
import Data.Time.Calendar

encryptAccountPassword account =
  account { crypted_password = encryptPassword $ crypted_password account }

saveAccount :: Account -> IO Account
saveAccount account = do
  let account' = encryptAccountPassword account
  conn <- connectDB
  _ <- execute conn "INSERT INTO users \
    \(name,email,crypted_password,created_at,updated_at) values \
    \(?,?,?,?,?)" account'
  results <- query_ conn "SELECT LAST_INSERT_ID()"
  let [Only accountId] = results
  return account' { Account.id = accountId }

findAccount :: Int -> IO Account
findAccount userId = do
  conn <- connectDB
  accountResults <- query conn "SELECT * FROM users WHERE id=?" (Only userId)
  case accountResults of
    [] -> do
      let defaultDate = (UTCTime (ModifiedJulianDay 0) 0)
      return $ Account 0 "" "" "" defaultDate defaultDate
    [account] -> return $ account


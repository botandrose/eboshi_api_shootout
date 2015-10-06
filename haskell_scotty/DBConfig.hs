{-# LANGUAGE OverloadedStrings #-}

module DBConfig (DBConfig(..), readDBConfig)
where

import System.Environment

data DBConfig = DBConfig {
      dbConfigUser :: String,
      dbConfigPassword :: String,
      dbConfigDatabase :: String }

readDBConfig :: IO DBConfig
readDBConfig = do
  userMaybe <- lookupEnv "EBOSHI_API_SHOOTOUT_MYSQL_USERNAME"
  user <- case userMaybe of
    Just string -> return string
    Nothing -> return "root"

  passwordMaybe <- lookupEnv "EBOSHI_API_SHOOTOUT_MYSQL_PASSWORD"
  password <- case passwordMaybe of
    Just string -> return string
    Nothing -> return ""

  databaseMaybe <- lookupEnv "EBOSHI_API_SHOOTOUT_MYSQL_DATABASE"
  database <- case databaseMaybe of
    Just string -> return string
    Nothing -> return ""

  return $ DBConfig user password database


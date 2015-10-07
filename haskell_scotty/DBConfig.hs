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
  user <- lookupEnvOrDefault "EBOSHI_API_SHOOTOUT_MYSQL_USERNAME" "root"
  password <- lookupEnvOrDefault "EBOSHI_API_SHOOTOUT_MYSQL_PASSWORD" ""
  database <- lookupEnvOrDefault "EBOSHI_API_SHOOTOUT_MYSQL_DATABASE" "eboshi_test"
  return $ DBConfig user password database

lookupEnvOrDefault :: String -> String -> IO String
lookupEnvOrDefault key defaultValue = do
  valueMaybe <- lookupEnv key
  value <- case valueMaybe of
    Just string -> return string
    Nothing -> return defaultValue
  return value


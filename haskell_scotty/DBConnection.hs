{-# LANGUAGE OverloadedStrings #-}
module DBConnection (connectDB) where

import Database.MySQL.Simple
import System.Environment

lookupEnvOrDefault :: String -> String -> IO String
lookupEnvOrDefault key defaultValue = do
  valueMaybe <- lookupEnv $ "EBOSHI_API_SHOOTOUT_MYSQL_" ++ key
  case valueMaybe of
    Just string -> return string
    Nothing -> return defaultValue

connectDB :: IO Connection
connectDB = do
  user <- lookupEnvOrDefault "USERNAME" "root"
  pass <- lookupEnvOrDefault "PASSWORD" ""
  database <- lookupEnvOrDefault "DATABASE" "eboshi_test"
  conn <- Database.MySQL.Simple.connect defaultConnectInfo {
    connectUser = user,
    connectPassword = pass,
    connectDatabase = database }
  return conn


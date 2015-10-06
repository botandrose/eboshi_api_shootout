{-# LANGUAGE OverloadedStrings #-}

module DBConfig (DBConfig(..), readDBConfig)
where

import Data.Aeson
import qualified Data.ByteString.Lazy as BS

data DBConfig = DBConfig {
      dbConfigUser :: String,
      dbConfigPassword :: String,
      dbConfigDatabase :: String }

instance FromJSON DBConfig where

  parseJSON (Object obj) = do
      user <- obj .: "user"
      password <- obj .: "password"
      database <- obj .: "database"
      return $ DBConfig user password database

  parseJSON _ = fail "unexpected user record"

readDBConfig :: IO DBConfig
readDBConfig = do
    jsonBS <- BS.readFile ".mysql-config"
    case decode jsonBS of
      Just cf -> return cf
      Nothing -> fail "could not read db config"

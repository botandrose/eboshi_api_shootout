{-# LANGUAGE OverloadedStrings #-}

module Auth where

import DBConnection
import Database.MySQL.Simple
import Control.Applicative
import Data.Aeson hiding (json)
import Encryption

authenticateAccount :: Auth -> IO Bool
authenticateAccount auth = do
  conn <- connectDB
  results <- query conn "SELECT COUNT(*) FROM users WHERE email=? AND crypted_password=?" (email auth, encryptPassword $ password $ auth)
  let [Only count] = results
  return ((count :: Int) == 1)

data Auth = Auth {
  email :: String,
  password :: String
}

instance FromJSON Auth where
  parseJSON (Object json) = do
    let attributes = (json .: "data") >>= (.: "attributes")
    Auth <$>
      (attributes >>= (.: "email")) <*>
      (attributes >>= (.: "password"))
  parseJSON _ = error "unexpected non-object JSON"


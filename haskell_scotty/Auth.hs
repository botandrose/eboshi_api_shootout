{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveDataTypeable #-}

module Auth where

import DBConnection
import Database.MySQL.Simple
import Control.Applicative
import qualified Data.Map as Map
import Data.Aeson hiding (json)
import Data.Data
import Encryption
import Web.JWT

authenticateAccount :: Auth -> IO Auth
authenticateAccount auth = do
  conn <- connectDB
  results <- query conn "SELECT id FROM users WHERE email=? AND crypted_password=?" (email auth, encryptPassword $ password $ auth)
  case results of
    [Only userId] -> return auth { Auth.userId = userId, isValid = True }
    _ -> return auth

data Auth = Auth {
  userId :: Int,
  email :: String,
  password :: String,
  isValid :: Bool
} deriving (Data, Typeable)

jwtToken auth =
  let key = secret "fart69"
      iss = stringOrURI "Eboshi"
      payload = Map.fromList [("id", toJSON $ userId $ auth)]
      claims = def { iss = iss, unregisteredClaims = payload }
  in encodeSigned HS256 key claims

instance ToJSON Auth where
  toJSON auth = object [
    "type" .= ("auth" :: String),
    "attributes" .= object [
      "email" .= email auth,
      "token" .= jwtToken auth ] ]

instance FromJSON Auth where
  parseJSON (Object json) = do
    let attributes = (json .: "data") >>= (.: "attributes")
    Auth <$>
      (parseJSON $ Number $ 0) <*>
      (attributes >>= (.: "email")) <*>
      (attributes >>= (.: "password")) <*>
      (parseJSON $ toJSON $ False)
  parseJSON _ = error "unexpected non-object JSON"

invalidAuthError = do
  object [
      "errors" .= [ object [
          "title" .= ("Invalid authentication credentials" :: String)
        ] ]
    ]

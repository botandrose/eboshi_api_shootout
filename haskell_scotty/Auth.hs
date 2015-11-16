{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveDataTypeable #-}

module Auth where

import DBConnection
import Database.MySQL.Simple
import Control.Applicative
import qualified Data.Map as Map
import Data.Aeson
import Data.Aeson.Types
import Data.Data
import Data.Text.Lazy
import Encryption
import Web.JWT hiding (decode)
import Data.Maybe

authenticateAccount :: Auth -> IO (Maybe Auth)
authenticateAccount auth = do
  conn <- connectDB
  results <- query conn "SELECT id FROM users WHERE email=? AND crypted_password=?" (email auth, encryptPassword $ password $ auth)
  case results of
    [Only userId] -> return (Just auth { Auth.userId = userId })
    _ -> return Nothing

data Auth = Auth {
  userId :: Int,
  email :: String,
  password :: String,
  key :: Text
} deriving (Data, Typeable)

jwtToken :: Auth -> JSON
jwtToken auth =
  let secretKey = secret $ toStrict $ key auth
      iss = stringOrURI "Eboshi"
      payload = Map.fromList [("id", toJSON $ userId $ auth)]
      claims = def { iss = iss, unregisteredClaims = payload }
  in encodeSigned HS256 secretKey claims

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
      (parseJSON $ "")
  parseJSON _ = error "unexpected non-object JSON"

invalidAuthCredentialsError = do
  object [
      "errors" .= [ object [
          "title" .= ("Invalid authentication credentials" :: String)
        ] ]
    ]

invalidAuthTokenError = do
  object [
      "errors" .= [ object [
          "title" .= ("Invalid authentication token" :: String)
        ] ]
    ]

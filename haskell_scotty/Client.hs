{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveDataTypeable #-}

module Client (Client(..)) where

import Prelude hiding (zip)

import Control.Applicative
import Data.Aeson hiding (json)
import Data.Data
import Data.Time.Clock (UTCTime)
import Data.Time.ISO8601
import Database.MySQL.Simple.QueryResults
import Database.MySQL.Simple.QueryParams
import Database.MySQL.Simple.Param

import ConstructResult

data Client = Client {
  id :: Int,
  name :: String,
  address :: String,
  city :: String,
  state :: String,
  zip :: String,
  country :: String,
  email :: String,
  contact :: String,
  phone :: String,
  created_at :: UTCTime,
  updated_at :: UTCTime
} deriving (Data, Typeable)

instance ToJSON Client where
  toJSON client = object [
    "type" .= ("clients" :: String),
    "id" .= show (Client.id client),
    "attributes" .= object [
      "name" .= name client,
      "address" .= address client,
      "city" .= city client,
      "state" .= state client,
      "zip" .= zip client,
      "country" .= country client,
      "email" .= email client,
      "contact" .= contact client,
      "phone" .= phone client,
      "created_at" .= formatISO8601 (created_at client),
      "updated_at" .= formatISO8601 (updated_at client) ] ]

instance FromJSON Client where
  parseJSON (Object json) = do
    let attributes = (json .: "data") >>= (.: "attributes")
    Client <$>
      (parseJSON $ Number $ 0) <*>
      (attributes >>= (.: "name")) <*>
      (attributes >>= (.: "address")) <*>
      (attributes >>= (.: "city")) <*>
      (attributes >>= (.: "state")) <*>
      (attributes >>= (.: "zip")) <*>
      (attributes >>= (.: "country")) <*>
      (attributes >>= (.: "email")) <*>
      (attributes >>= (.: "contact")) <*>
      (attributes >>= (.: "phone")) <*>
      (attributes >>= (.: "created_at")) <*>
      (attributes >>= (.: "updated_at"))
  parseJSON _ = error "unexpected non-object JSON"

instance QueryResults Client where
  convertResults fs vs =
      Client $... constructorWrap (undefined :: Client) fs vs

instance QueryParams Client where
  renderParams
    (Client _ name' address' city' state' zip' country' email' contact' phone' created_at' updated_at') =
      [render name', render address', render city', render state', render zip', render country', render email', render contact', render phone', render created_at', render updated_at']

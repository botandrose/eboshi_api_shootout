{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveDataTypeable #-}

module Client (Client(..)) where

import Prelude hiding (zip)

import Data.Aeson
import Data.Data
import Data.Time.Clock (UTCTime)
import Data.Time.ISO8601

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

{-# LANGUAGE OverloadedStrings #-}

module Account (Account(..)) where

import Control.Applicative
import Data.Aeson hiding (json)
import Data.Time.Clock (UTCTime)
import Data.Time.ISO8601

data Account = Account {
  id :: Int,
  name :: String,
  email :: String,
  created_at :: UTCTime,
  updated_at :: UTCTime
}

instance ToJSON Account where
  toJSON account = object [
    "type" .= ("accounts" :: String),
    "id" .= show (Account.id account),
    "attributes" .= object [
      "name" .= name account,
      "email" .= email account,
      "created_at" .= formatISO8601 (created_at account),
      "updated_at" .= formatISO8601 (updated_at account) ] ]

instance FromJSON Account where
  parseJSON (Object json) = do
    let attributes = (json .: "data") >>= (.: "attributes")
    Account <$>
      (parseJSON $ Number $ 0) <*>
      (attributes >>= (.: "name")) <*>
      (attributes >>= (.: "email")) <*>
      (parseJSON "1000-01-01T00:00:00Z") <*> -- FIXME get default values working
      (parseJSON "1000-01-01T00:00:00Z")
  parseJSON _ = error "unexpected non-object JSON"


{-# LANGUAGE OverloadedStrings #-}

module AccountRepo (saveAccount) where

import Data.Aeson (object, (.=), ToJSON, Value)

saveAccount = do
  object [
      "type" .= ("accounts" :: String),
      "id" .= ("1" :: String),
      "attributes" .= object [
          "name" .= ("Micah Geisel" :: String),
          "email" .= ("micah@botandrose.com" :: String),
          "created_at" .= ("1000-10-10T10:10:10Z" :: String),
          "updated_at" .= ("1000-10-10T10:10:10Z" :: String)
        ]
    ]


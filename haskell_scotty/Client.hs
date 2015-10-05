{-# LANGUAGE OverloadedStrings #-}
module Client where

import Data.Aeson

data Client = Client {
  id :: String,
  name :: String,
  address :: String,
  city :: String,
  state :: String,
  zip :: String,
  country :: String,
  email :: String,
  contact :: String,
  phone :: String,
  created_at :: String,
  updated_at :: String
}

instance ToJSON Client where
  toJSON client = object [
    "data" .= [ object [
      "type" .= ("clients" :: String),
      "id" .= Client.id client,
      "attributes" .= object [
        "name" .= name client,
        "address" .= address client,
        "city" .= city client,
        "state" .= state client,
        "zip" .= Client.zip client,
        "country" .= country client,
        "email" .= email client,
        "contact" .= contact client,
        "phone" .= phone client,
        "created_at" .= created_at client,
        "updated_at" .= updated_at client ] ] ] ]



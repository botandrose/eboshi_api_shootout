{-# LANGUAGE OverloadedStrings #-}

import Web.Scotty
import Data.Aeson

main :: IO ()
main = scotty 6969 $ do
  get "/api/test" $ do
    html "Hello world"

  get "/api/clients" $ do
    Web.Scotty.json Client {
      Main.id="1",
      name="Bot and Rose Design",
      address="625 NW Everett St",
      city="Portland",
      state="OR",
      Main.zip="97209",
      country="USA",
      email="info@botandrose.com",
      contact="Michael Gubitosa",
      phone="(503) 662-2712",
      created_at="2006-06-25T14:08:31Z",
      updated_at="2015-08-29T09:58:23Z"
    }

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
      "id" .= Main.id client,
      "attributes" .= object [
        "name" .= name client,
        "address" .= address client,
        "city" .= city client,
        "state" .= state client,
        "zip" .= Main.zip client,
        "country" .= country client,
        "email" .= email client,
        "contact" .= contact client,
        "phone" .= phone client,
        "created_at" .= created_at client,
        "updated_at" .= updated_at client ] ] ] ]



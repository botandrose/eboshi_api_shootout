{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

import Web.Scotty
import Data.Aeson
import GHC.Generics

main :: IO ()
main = scotty 6969 $ do
  get "/api/test" $ do
    html "Hello world"

  get "/api/clients" $ do
    Web.Scotty.json ClientResponseWrapper {
      dada=[
        ClientResponse {
          tipe="clients",
          Main.id="1",
          attributes=ClientAttributes {
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
        }
      ]
    }

data ClientResponseWrapper = ClientResponseWrapper {
  dada :: [ClientResponse]
}
instance ToJSON ClientResponseWrapper where
  toJSON p = object [ "data" .= dada p ]

data ClientResponse = ClientResponse {
  tipe :: String,
  id :: String,
  attributes :: ClientAttributes
}
instance ToJSON ClientResponse where
  toJSON p = object [ "type" .= tipe p, "id" .= Main.id p, "attributes" .= attributes p ]

data ClientAttributes = ClientAttributes {
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
} deriving Generic
instance ToJSON ClientAttributes


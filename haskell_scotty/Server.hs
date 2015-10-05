{-# LANGUAGE OverloadedStrings #-}
import Web.Scotty
import Client

main :: IO ()
main = scotty 6969 $ do
  get "/api/test" $ do
    html "Hello world"

  get "/api/clients" $ do
    json Client {
      Client.id="1",
      name="Bot and Rose Design",
      address="625 NW Everett St",
      city="Portland",
      state="OR",
      Client.zip="97209",
      country="USA",
      email="info@botandrose.com",
      contact="Michael Gubitosa",
      phone="(503) 662-2712",
      created_at="2006-06-25T14:08:31Z",
      updated_at="2015-08-29T09:58:23Z"
    }


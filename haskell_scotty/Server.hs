{-# LANGUAGE OverloadedStrings #-}

import Web.Scotty
import Network.HTTP.Types.Status
import ClientRepo
import Control.Monad.IO.Class
import JSONAPIResponse
import Client

main :: IO ()
main = scotty 6969 $ do
  get "/api/test" $ do
    html "Hello world"

  get "/api/clients" $ do
    clients <- liftIO getClients
    json $ dataResponse $ clients

  post "/api/clients" $ do
    client <- jsonData
    client <- liftIO $ saveClient client
    json $ dataResponse $ client
    status status201


{-# LANGUAGE OverloadedStrings #-}

import Web.Scotty
import Network.HTTP.Types.Status
import ClientRepo
import Control.Monad.IO.Class
import JSONAPIResponse (dataResponse)
import Data.Aeson (ToJSON)

main :: IO ()
main = scotty 6969 $ do
  get "/api/test" $ do
    html "Hello world"

  post "/api/account" $ do
    text "{ \"data\": { \"type\": \"accounts\", \"id\": \"1\", \"attributes\": { \"name\": \"Micah Geisel\", \"email\": \"micah@botandrose.com\", \"created_at\": \"1000-10-10T10:10:10Z\", \"updated_at\": \"1000-10-10T10:10:10Z\" } } }"
    status status201

  get "/api/clients" $ do
    clients <- liftIO getClients
    jsonAPI clients

  post "/api/clients" $ do
    client <- jsonData
    client' <- liftIO $ saveClient client
    jsonAPI client'
    status status201

  delete "/api/clients/:id" $ do
    clientId <- param "id"
    liftIO $ deleteClient clientId
    status status204

jsonAPI :: ToJSON s => s -> ActionM ()
jsonAPI resource = json $ dataResponse $ resource

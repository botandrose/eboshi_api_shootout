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

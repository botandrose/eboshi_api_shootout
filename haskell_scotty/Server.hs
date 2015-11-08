{-# LANGUAGE OverloadedStrings #-}

import Web.Scotty
import Network.HTTP.Types.Status
import ClientRepo
import AccountRepo
import Account
import Auth
import Control.Monad.IO.Class
import JSONAPIResponse (dataResponse)
import Data.Aeson hiding (json)

main :: IO ()
main = scotty 6969 $ do
  get "/api/test" $ do
    html "Hello world"

  post "/api/account" $ do
    account <- jsonData
    account' <- liftIO $ saveAccount account
    jsonAPI account'
    status status201

  post "/api/auth" $ do
    auth <- jsonData
    isAuthenticated <- liftIO $ authenticateAccount auth
    if isAuthenticated
      then do
        json $ object [
            "data" .= object [
                "type" .= ("auth" :: String),
                "attributes" .= object [
                    "email" .= ("micah@botandrose.com" :: String),
                    "token" .= ("asdf.asdf.asdf" :: String)
                  ]
              ]
          ]
        status status200
      else do
        json $ object [
            "errors" .= [ object [
                "title" .= ("Invalid authentication credentials" :: String)
              ] ]
          ]
        status status401

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

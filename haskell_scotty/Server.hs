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
import Data.Maybe
import Data.Text.Lazy

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
    auth' <- liftIO $ authenticateAccount auth
    if isValid auth'
      then do
        jsonAPI auth'
        status status200
      else do
        json $ invalidAuthCredentialsError
        status status401

  get "/api/greet" $ do
    authorizationMaybe <- header "Authorization"
    case authorizationMaybe of
      Just authHeader -> do
        let userId = userIdFromHeader authHeader
        account <- liftIO $ findAccount userId
        case Account.id account of
          0 -> do
            json invalidAuthTokenError
            status status401
          _ -> do
            let message = (append (append "Hello, " (pack (name account))) "!")
            text $ message
            status status200
      _ -> do
        json invalidAuthTokenError
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

{-# LANGUAGE OverloadedStrings #-}

import Web.Scotty
import Network.HTTP.Types.Status
import ClientRepo
import AccountRepo
import Account
import Auth
import Control.Applicative
import Control.Monad.IO.Class
import JSONAPIResponse (dataResponse)
import Data.Aeson hiding (json)
import Data.Maybe
import Data.Text.Lazy

getCurrentAccount :: ActionM (Maybe Account)
getCurrentAccount = do
  authorizationMaybe <- header "Authorization"
  let userIdMaybe = do
                      authorization <- authorizationMaybe
                      userIdFromHeader authorization
  case userIdMaybe of
    Just userId -> liftIO $ findAccount $ userId
    Nothing -> return Nothing

main :: IO ()
main = scotty 6969 $ do
  get "/api/test" $ do
    html "Hello world"

  get "/api/account" $ do
    accountMaybe <- getCurrentAccount
    case accountMaybe of
      Just account -> do
        jsonAPI account
        status status200
      Nothing -> do
        json invalidAuthTokenError
        status status401

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

{-# LANGUAGE OverloadedStrings #-}

module CurrentAccount (currentAccount) where

import Web.Scotty
import AccountRepo
import Account
import Auth
import Control.Monad.IO.Class
import Data.Text.Lazy
import Web.JWT hiding (decode, header)
import Data.Maybe
import qualified Data.Map as Map
import Data.Aeson

currentAccount :: ActionM (Maybe Account)
currentAccount = do
  headerMaybe <- header "Authorization"
  maybeToMonad headerMaybe (liftIO . findAccountFromHeader)

maybeToMonad :: Monad m => Maybe a -> (a -> m (Maybe b)) -> m (Maybe b)
maybeToMonad valueMaybe action =
  case valueMaybe of
    Just value -> action value
    Nothing -> return Nothing

findAccountFromHeader :: Text -> IO (Maybe Account)
findAccountFromHeader authHeader =
  maybeToMonad (userIdFromHeader authHeader) findAccount

userIdFromHeader :: Text -> Maybe Int
userIdFromHeader header =
  let token = replace "Bearer " "" header
      jwtMaybe = decodeAndVerifySignature (secret "fart69") (toStrict token) in
  fmap (extractIdFromPayload . unregisteredClaims . claims) jwtMaybe

extractIdFromPayload :: ClaimsMap -> Int
extractIdFromPayload claims =
  let idValue = fromJust $ Map.lookup "id" claims
      userIdResult = fromJSON $ idValue
  in case (userIdResult :: Result Int) of
    Success userId -> userId


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

currentAccount :: Text -> ActionM (Maybe Account)
currentAccount key = do
  headerMaybe <- header "Authorization"
  maybeToMonad headerMaybe (liftIO . findAccountFromKeyAndHeader key)

maybeToMonad :: Monad m => Maybe a -> (a -> m (Maybe b)) -> m (Maybe b)
maybeToMonad valueMaybe action =
  case valueMaybe of
    Just value -> action value
    Nothing -> return Nothing

findAccountFromKeyAndHeader :: Text -> Text -> IO (Maybe Account)
findAccountFromKeyAndHeader key authHeader =
  maybeToMonad (userIdFromKeyAndHeader key authHeader) findAccount

userIdFromKeyAndHeader :: Text -> Text -> Maybe Int
userIdFromKeyAndHeader key header =
  let token = replace "Bearer " "" header
      jwtMaybe = decodeAndVerifySignature (secret (toStrict key)) (toStrict token) in
  fmap (extractIdFromPayload . unregisteredClaims . claims) jwtMaybe

extractIdFromPayload :: ClaimsMap -> Int
extractIdFromPayload claims =
  let idValue = fromJust $ Map.lookup "id" claims
      userIdResult = fromJSON $ idValue
  in case (userIdResult :: Result Int) of
    Success userId -> userId


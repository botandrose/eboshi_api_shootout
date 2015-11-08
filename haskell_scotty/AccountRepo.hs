{-# LANGUAGE OverloadedStrings #-}

module AccountRepo (saveAccount) where

import Account
import Data.Aeson (object, (.=), ToJSON, Value)

saveAccount :: Account -> IO Account
saveAccount account = do
  return account { Account.id = 1 }


module Encryption (encryptPassword) where

import Crypto.Hash.SHA512 (hash)
import Data.ByteString.Char8 (pack, unpack)

encryptPassword :: String -> String
encryptPassword password =
  unpack $ hash $ pack $ password


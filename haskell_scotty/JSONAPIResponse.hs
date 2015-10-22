{-# LANGUAGE OverloadedStrings #-}
module JSONAPIResponse (dataResponse) where

import Data.Aeson (object, (.=), ToJSON, Value)

dataResponse :: ToJSON a => a -> Value
dataResponse jsonable =
    object [ "data" .= jsonable ]


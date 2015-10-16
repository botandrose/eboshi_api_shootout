{-# LANGUAGE OverloadedStrings #-}
module JSONAPIResponse (dataResponse) where

import Data.Aeson (object, (.=))

dataResponse jsonable =
    object [ "data" .= jsonable ]


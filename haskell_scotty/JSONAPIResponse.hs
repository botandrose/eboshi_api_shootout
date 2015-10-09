{-# LANGUAGE OverloadedStrings #-}
module JSONAPIResponse where

import Data.Aeson (object, (.=))

dataResponse jsonable =
    object [ "data" .= jsonable ]


{-# LANGUAGE OverloadedStrings #-}

import Web.Scotty
import ClientRepo
import Control.Monad.IO.Class
import JSONAPIResponse

main :: IO ()
main = scotty 6969 $ do
  get "/api/test" $ do
    html "Hello world"

  get "/api/clients" $ do
    clients <- liftIO getClients
    json $ dataResponse $ clients


{-# LANGUAGE OverloadedStrings #-}

import Web.Scotty
import FetchClients
import Control.Monad.IO.Class

main :: IO ()
main = scotty 6969 $ do
  get "/api/test" $ do
    html "Hello world"

  get "/api/clients" $ do
    clients <- liftIO fetchClients
    json $ head clients


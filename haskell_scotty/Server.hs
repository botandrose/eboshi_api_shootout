{-# LANGUAGE OverloadedStrings #-}

import Web.Scotty
import FetchClients
import Control.Monad.IO.Class

-- | Generate a simple test page.
testPage :: ActionM ()
testPage = html "Hello world"

-- | Respond to an API "clients" request with JSON.
clientsPage :: ActionM ()
clientsPage = do
  clients <- liftIO fetchClients
  json $ head clients

-- | Provide the top-level API.
main :: IO ()
main = scotty 6969 $ do
  get "/api/test" testPage
  get "/api/clients" clientsPage


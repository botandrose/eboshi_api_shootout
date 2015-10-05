{-# LANGUAGE OverloadedStrings #-}
import Web.Scotty
import Network.HTTP.Types.Status

-- | Build a basic test page.
helloTestPage :: ActionM ()
helloTestPage = html "Hello world"

-- | Build a test page and do some status stuff.
compoundTestPage :: ActionM ()
compoundTestPage = do
  html "You are not supposed to be here."
  status badRequest400

-- | Specify the behavior of each API endpoint.
router :: ScottyM ()
router = do
  get "/api/test" helloTestPage
  get "/api/test2" compoundTestPage

-- | Construct the actual webserver.
main :: IO ()
main = scotty 6969 router


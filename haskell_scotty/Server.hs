{-# LANGUAGE OverloadedStrings #-}
import Web.Scotty

main = scotty 6969 $ do
    get "/api/test" $ do
        html "Hello world"


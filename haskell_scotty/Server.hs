{-# LANGUAGE OverloadedStrings #-}
import Web.Scotty

main :: IO ()
main =
    scotty 6969 $
    get "/api/test" $
    html "Hello world"


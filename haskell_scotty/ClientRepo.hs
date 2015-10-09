{-# LANGUAGE OverloadedStrings #-}
module ClientRepo where

import Client
import DBConnection
import Database.MySQL.Simple
import Database.MySQL.Simple.Result
import Database.MySQL.Simple.QueryResults

all :: IO [Client]
all = do
  conn <- DBConnection.connect
  clients <- query_ conn "SELECT * FROM clients"
  return clients

instance QueryResults Client where
  convertResults [fa,fb,fc,fd,fe,ff,fg,fh,fi,fj,fk,fl] [va,vb,vc,vd,ve,vf,vg,vh,vi,vj,vk,vl] =
    Client a b c d e f g h i j k l 
      where a = convert fa va
            b = convert fb vb
            c = convert fc vc
            d = convert fd vd
            e = convert fe ve
            f = convert ff vf
            g = convert fg vg
            h = convert fh vh
            i = convert fi vi
            j = convert fj vj
            k = convert fk vk
            l = convert fl vl


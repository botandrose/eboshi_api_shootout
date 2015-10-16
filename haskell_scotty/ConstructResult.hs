{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverlappingInstances #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE ExistentialQuantification #-}

module ConstructResult (ConstructorApply(..)) where

import qualified Data.ByteString as BS
import Database.MySQL.Base.Types
import Database.MySQL.Simple.Result

class ConstructorApply f r | f -> r where
    ($...) :: f -> [(Field, Maybe BS.ByteString)] -> r

instance b ~ r => ConstructorApply b r where
    x $... [] = x
    _ $... _ = error "too many arguments"

instance (Result a, ConstructorApply f r) => ConstructorApply (a -> f) r where
    f $... (x : xs) = (f $ uncurry convert x) $... xs
    _ $... [] = error "too few arguments"

-- We use a lot of GHC extensions here to get the type magic
-- to work.

{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverlappingInstances #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE TypeFamilies #-}

-- | Support code for @mysql-simple@ to allow convenient
-- populating of Haskell records from database rows.
-- To use this module, you will need to instance
-- `QueryResults` on your constructor with a
-- `convertResults` that packages the record fields up:
-- something like
--
-- > instance QueryResults MyRecord where
-- >   convertResults fs vs =
-- >       MyRecord $... constructorWrap (undefined :: MyRecord) fs vs
--
-- General approach is from
-- <http://stackoverflow.com/a/2900326/364875>, but
-- with `TypeClass` replaced with the @~@ operator from the
-- GHC `TypeFamilies` extension as suggested by someone on
-- the Internet, and with some modifications to the
-- approach to tackle this specific case cleanly.
--
-- Arguably this module belongs in @mysql-simple@.
module ConstructResult (ConstructorApply(..), constructorWrap) where

import qualified Data.ByteString as BS
import Data.Data
import Database.MySQL.Base.Types
import Database.MySQL.Simple.Result

-- | Inspired by <http://stackoverflow.com/a/8458117/364875>.
-- Check for database field names mismatching with constructor
-- field names.
--
-- XXX This should be type-hacked to allow not requiring
-- the stupid template value.
constructorWrap :: (Data a, Typeable a) => a ->
                   [Field] -> [Maybe BS.ByteString] ->
                   [(Field, Maybe BS.ByteString)]
constructorWrap c fs vs =
    zip fs' vs
    where
      fs' = zipWith combine cs fs
            where
              combine cf dbf
                  | cf == dbfs = dbf
                  | otherwise = error $ "constructor field name mismatch: " ++
                                cf ++ " / " ++ dbfs
                  where
                    dbfs = show $ fieldName dbf
      cs = constrFields $ flip indexConstr 1 $ dataTypeOf c

-- | Type class to allow a database row
-- to be translated into an appropriate Haskell record
-- field-by-field based on field type. The approach
-- is to repeatedly partially apply the record constructor.
class ConstructorApply f r | f -> r where
    -- | Apply the record constructor on the left to the
    -- database row list on the right.
    ($...) :: f -> [(Field, Maybe BS.ByteString)] -> r

-- | This instance handles returning the resulting Haskell
-- record.
instance b ~ r => ConstructorApply b r where
    x $... [] = x
    _ $... _ = error "too many arguments"

-- | This instance handles extending the partial record
-- constructor to cover another field.
instance (Result a, ConstructorApply f r) => ConstructorApply (a -> f) r where
    f $... (x : xs) =
        (f $ uncurry convert x) $... xs
    _ $... [] = error "too few arguments"

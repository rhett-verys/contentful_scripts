{-# LANGUAGE OverloadedStrings #-}

module Models.Sku where

import Models.GlobalModels (SysItem, SysLink)
import Control.Monad
import Data.Aeson
import Data.Time.Clock
import Data.Time.Format

data AllSkuQuery = AllSkuQuery {
  topSys :: SysLink
  , total    :: Integer
  , skip     :: Integer
  , limit    :: Integer
  , items    :: [SkuItem]
} deriving (Show, Eq)

instance FromJSON AllSkuQuery where
    parseJSON (Object o) =
      AllSkuQuery <$> (o .: "sys")
                  <*> (o .: "total")
                  <*> (o .: "skip")
                  <*> (o .: "limit")
                  <*> (o .: "items")
    parseJSON _          = mzero

data SkuItem = SkuItem {
  sys :: SysItem
  , fields :: SkuField
} deriving (Show, Eq)

instance FromJSON SkuItem where
    parseJSON (Object o) = SkuItem <$> (o .: "sys") <*> (o .: "fields")
    parseJSON _          = mzero

data SkuField = SkuField {
  title :: String
  , referenceId :: String
  , customBackgroundImage :: SysLink
  , features :: [SysLink]
  , shortDescription :: String
} deriving (Show,Eq)

instance FromJSON SkuField where
    parseJSON (Object o) = 
        SkuField <$> (o .: "title") 
                 <*> (o .: "referenceId")
                 <*> (o .: "customBackgroundImage")
                 <*> (o .: "features")
                 <*> (o .: "shortDescription")
    parseJSON _          = mzero
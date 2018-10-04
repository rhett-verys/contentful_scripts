{-# LANGUAGE OverloadedStrings #-}

module Models.Developer where

import Models.GlobalModels (SysItem, SysLink)
import Control.Monad
import Data.Aeson
import Data.Time.Clock
import Data.Time.Format

data AllDeveloperQuery = AllDeveloperQuery {
  topSys :: SysLink
  , total    :: Integer
  , skip     :: Integer
  , limit    :: Integer
  , items    :: [DeveloperItem]
} deriving (Show, Eq)

instance FromJSON AllDeveloperQuery where
    parseJSON (Object o) =
      AllDeveloperQuery <$> (o .: "sys")
                        <*> (o .: "total")
                        <*> (o .: "skip")
                        <*> (o .: "limit")
                        <*> (o .: "items")
    parseJSON _          = mzero

data DeveloperItem = DeveloperItem {
  sys :: SysItem
  , fields :: DeveloperField
} deriving (Show, Eq)

instance FromJSON DeveloperItem where
    parseJSON (Object o) = DeveloperItem <$> (o .: "sys") <*> (o .: "fields")
    parseJSON _          = mzero

data DeveloperField = DeveloperField {
  entryTitle :: String
  , name :: String
  , logo :: SysLink
} deriving (Show,Eq)

instance FromJSON DeveloperField where
    parseJSON (Object o) = 
        DeveloperField <$> (o .: "entryTitle") 
                       <*> (o .: "name")
                       <*> (o .: "logo")
    parseJSON _          = mzero
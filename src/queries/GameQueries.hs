{-# LANGUAGE OverloadedStrings #-}
module Queries.GameQueries(
    getAllGamesIO
) where

import Network.HTTP.Conduit
import Network.HTTP.Simple
import Network.HTTP.Client (setQueryString)
import Data.ByteString.Base64
import Data.ByteString.UTF8 hiding (foldl)
import Data.Foldable (foldl)
import Data.Monoid
import System.Environment (getEnv)
import Control.Applicative


import Models.Games

data EnvironmentConfig = EnvironmentConfig {
      preview_access_token_prod :: EnvironmentValue
    , space_contentful_launcher_prod :: EnvironmentValue
    , preview_access_token_sandbox :: EnvironmentValue
    , space_contentful_launcher_sandbox :: EnvironmentValue
}
type EnvironmentValue = String

makeUrlFromSpace :: Request --sandbox
makeUrlFromSpace = "GET https://preview.contentful.com/spaces/52kyweqkx3gp/environments/master/entries?"

buildQueryGames :: ByteString -> [(ByteString, Maybe ByteString)]
buildQueryGames token = [("access_token", Just token), ("content_type", Just "game")]

getEnvironmentVars :: IO EnvironmentConfig
getEnvironmentVars = do 
    token_prod <- getEnv "PREVIEW_ACCESS_TOKEN_PROD"
    space_prod <- getEnv "SPACE_CONTENTFUL_LAUNCHER_PROD"
    token_sandbox <- getEnv "PREVIEW_ACCESS_TOKEN"
    space_sandbox <- getEnv "SPACE_CONTENTFUL"
    return $ EnvironmentConfig token_prod space_prod token_sandbox space_sandbox

getGamesAPI :: [(ByteString, Maybe ByteString)] -> IO AllGamesQuery
getGamesAPI query = do
    let request = setQueryString query makeUrlFromSpace
    response <- httpJSON request
    return $ getResponseBody response

-- top level interface
getAllGamesIO :: IO [GameItem]
getAllGamesIO = do
    config <- getEnvironmentVars
    gs <- getGamesAPI $ buildQueryGames $ fromString $ preview_access_token_sandbox config
    return $ items gs
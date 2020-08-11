{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}

module Main where

import Control.Monad.Trans (liftIO)
import Data.Aeson
import Data.Proxy
import Data.Text (Text)
import Data.Text as T
import GHC.Generics
import Network.HTTP.Client (newManager, defaultManagerSettings)
import Network.Wai
import Network.Wai.Handler.Warp
import Network.Wai.Logger (withStdoutLogger)
import Servant
import Servant.API
import Servant.Client
import System.Environment

data NeoTokenV1CheckResponse =
  NeoTokenIsAuth {
    ntcrAuthentification :: Bool
    , ntcrUid :: Text
  }
  | NeoTokenIsUnAuth {
    ntcrError :: Int
    , ntcrMsg :: Text
  } deriving (Generic, Show)

instance ToJSON NeoTokenV1CheckResponse where
  toJSON (NeoTokenIsAuth auth uid) = object ["authentification" .= auth, "uid" .= uid]
  toJSON (NeoTokenIsUnAuth code msg) = object ["error" .= code, "msg" .= msg]

instance FromJSON NeoTokenV1CheckResponse where
  parseJSON (Object v) = NeoTokenIsAuth <$> v .: "authentification" <*> v .: "uid"

type NeoTokenV1 = "token" :> "check" :> QueryParam "uid" Text :> QueryParam "token" Text :> Get '[JSON] NeoTokenV1CheckResponse

neoToken :: Proxy NeoTokenV1
neoToken = Proxy

neoTokenV1API :: Maybe Text -> Maybe Text -> Handler NeoTokenV1CheckResponse
neoTokenV1API (Just uid) (Just token) = case token of
  "ok" -> return NeoTokenIsAuth { ntcrAuthentification = True, ntcrUid = "uidok" }
  "ko" -> throwError err401 { errBody = "ko" }
  _ -> return NeoTokenIsAuth { ntcrAuthentification = True, ntcrUid = "untoken" }
neoTokenV1API _ _ = throwError err401 { errBody = "manque un ou des param(s)" }

srvNeoTokenV1 :: Server NeoTokenV1
srvNeoTokenV1 = neoTokenV1API

appNeoToken :: Application
appNeoToken = serve neoToken srvNeoTokenV1

main :: IO ()
main = do

  args <- getArgs

  case args of
    [ port ] ->
      withStdoutLogger $ \aplogger -> do
        let settings = setPort (read port :: Int) $ setLogger aplogger defaultSettings
        putStrLn $ "Listen neotoken-v2 plug :" <> port <> " ..."
        runSettings settings appNeoToken
    _ -> putStrLn "usage: neotoken-v2-plug [port:INT]"

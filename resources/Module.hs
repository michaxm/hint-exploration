module Module where

import Codec.Compression.GZip
import Data.ByteString.Lazy.Char8 as BLC

f :: BLC.ByteString -> BLC.ByteString
f = compress . (BLC.append $ BLC.pack "prefix")

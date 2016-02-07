module Main where

import Control.Concurrent.Async
import qualified Data.ByteString.Lazy.Char8 as BLC
import Language.Haskell.Interpreter

main :: IO ()
main = do
  threads <- mapM (async . runSingle) ["qwe", "sdf", "xxx"]
  mapM_ wait threads

runSingle :: String -> IO ()
runSingle input = do
  r <- runInterpreter $ testHint input
  case r of
   Left err -> printInterpreterError err
   Right () -> putStrLn "that's all folks"

-- observe that Interpreter () is an alias for InterpreterT IO ()
testHint :: String -> Interpreter ()
testHint input =
  do
    loadModules ["resources/Module.hs"]
    setTopLevelModules ["Module"]
    setImportsQ [("Prelude", Nothing), ("Data.ByteString.Lazy.Char8", Just "BLC")]
    f <- interpret "f" (as :: BLC.ByteString -> BLC.ByteString)
    res <- return (f (BLC.pack input) :: BLC.ByteString)
    say $ show $ res
      
say :: String -> Interpreter ()
say = liftIO . putStrLn

printInterpreterError :: InterpreterError -> IO ()
printInterpreterError e = putStrLn $ "Ups... " ++ (show e)

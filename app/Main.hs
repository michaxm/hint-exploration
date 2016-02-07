module Main where

import qualified Data.ByteString.Lazy.Char8 as BLC
import Language.Haskell.Interpreter

main :: IO ()
main = do r <- runInterpreter testHint
          case r of
            Left err -> printInterpreterError err
            Right () -> putStrLn "that's all folks"

-- observe that Interpreter () is an alias for InterpreterT IO ()
testHint :: Interpreter ()
testHint =
    do
      loadModules ["resources/Module.hs"]
      setTopLevelModules ["Module"]
      setImportsQ [("Prelude", Nothing), ("Data.ByteString.Lazy.Char8", Just "BLC")]
      f <- interpret "f" (as :: BLC.ByteString -> BLC.ByteString)
      res <- return (f (BLC.pack "qwe") :: BLC.ByteString)
      say $ show $ res
      
say :: String -> Interpreter ()
say = liftIO . putStrLn

printInterpreterError :: InterpreterError -> IO ()
printInterpreterError e = putStrLn $ "Ups... " ++ (show e)

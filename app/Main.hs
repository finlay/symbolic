module Main where

import qualified Symbolic (someFunc)

main :: IO ()
main = do
  putStrLn "Hello, Haskell!"
  Symbolic.someFunc

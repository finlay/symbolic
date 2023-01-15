{-# LANGUAGE OverloadedStrings #-}
module Main where

import Data.Text (Text)
import qualified Data.Text.IO as Text


data H = E | I | J | K deriving (Eq, Ord)
toStr :: H -> Text
toStr E = "\\1"
toStr I = "\\i"
toStr J = "\\j"
toStr K = "\\k"
basis :: [H]
basis = [ E, I, J, K ]


main :: IO ()
main = do
  let ls = [ toStr x <> " \\otimes " <> toStr y | x <- basis, y <- basis]
  mapM_ Text.putStrLn  ls

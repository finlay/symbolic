{-# OPTIONS_GHC -Wno-orphans #-}
module Main where

import Prelude hiding ((+), (-), (*), (^), negate, (>), (<), sum, fromInteger)

import Numeric.Quaternion hiding (x,y)
import Numeric.Extensive

-- Brauer map
br :: T (Tensor H H) -> T (Hom H H)
br = extend $ hom . br'
  where
    br' :: Tensor H H -> T H -> T H
    br' (Tensor x y) tz = let tx = return x
                              ty = return y
                          in  tx * tz * ty

invbr :: T (Hom H H) -> T (Tensor H H)
invbr = inverse br

rows :: [ (T (Tensor H H), T (Hom H H)) ]
rows =  [ (p `tensor` q,   br (p `tensor` q))
        | p <- basis , q <- basis ]

ee :: H -> String
ee E = " \\e^0 "
ee I = " \\e^1 "
ee J = " \\e^2 "
ee K = " \\e^3 "

ep :: H -> String
ep E = " \\ep_0 "
ep I = " \\ep_1 "
ep J = " \\ep_2 "
ep K = " \\ep_3 "

instance Tex (Hom H H) where
    tex (Hom x y) = ee y ++ " \\otimes " ++ ep x


main :: IO ()
main = do
  let stripPlus :: String -> String
      stripPlus (' ':'+':rest) = rest
      stripPlus rest = rest

  let showRow :: (Tex a, Tex b) =>  (a, b) -> String
      showRow (poq, res) =
        (stripPlus (tex poq)) <> " &= " <> tex res <> "\\\\"

  mapM_ (putStrLn . showRow) rows

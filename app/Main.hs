{-# OPTIONS_GHC -Wno-orphans #-}
module Main where

import Prelude hiding ((+), (-), (*), (^), negate, (>), (<), sum, fromInteger)
import System.Environment (getArgs)
import System.Exit (exitFailure)
import Data.List (sortOn, groupBy, intercalate)

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

e1 :: H -> String
e1 E = " \\1 "
e1 I = " \\i "
e1 J = " \\j "
e1 K = " \\k "


instance Tex (Hom H H) where
    tex (Hom x y) = ee y ++ " \\otimes " ++ ep x


brauer :: IO ()
brauer = do
  let showRow :: (Tex a, Tex b) =>  (a, b) -> String
      showRow (poq, res) =
        (stripPlus (tex poq)) <> " &= " <> tex res <> "\\\\"

  mapM_ (putStrLn . showRow) rows

-- Expanding f = p \otimes q
ps, qs, xs, fexp' :: [ (String, T H) ]
ps = zip ["p_0", "p_1", "p_2", "p_3"] basis
qs = zip ["q_0", "q_1", "q_2", "q_3"] basis
xs = zip ["t", "x", "y", "z"] basis
fexp' = [ (p <> " " <> x <> " " <> q, p2 * x2 * q2)
       | (p, p2) <- ps
       , (x, x2) <- xs
       , (q, q2) <- qs ]

fexp :: [ (String, H) ]
fexp = [ (sc c s, b) | (s, v) <- fexp', (b, c) <- coef' v]
  where
    coef' = filter (\(_,c) -> c /= 0) . coefficients
    sc c s
      | c == 1.0   = " + " <> s
      | c == -1.0  = " - " <> s
      | otherwise  = (show c) <> s

fcol :: [ ((String, String), H) ]
fcol =
  let fs = groupBy ( flip ((==) . snd ) . snd) (sortOn snd fexp)
      cc :: ([String], [String]) -> (String, String)
      cc (as, bs) = (concat as, concat bs)
      cs = map (cc . splitAt 8 . map fst) fs
      b = map (head . map snd ) fs
  in zip cs b

fexpand :: IO ()
fexpand = do
  let showRow :: ((String, String), H) -> String
      showRow ((cs1, cs2), be) =
        "(" <> (stripPlus cs1) <> "\\\\\n & " <> cs2 <> ")" <> e1 be <> "\\\\\n"
  putStr $ "&= " <> (intercalate " &+ " $ map showRow fcol)


stripPlus :: String -> String
stripPlus (' ':'+':rest) = rest
stripPlus rest = rest



main :: IO ()
main = do
  args <- getArgs
  case args of
    ["brauer"]     -> brauer
    ["fexpand"]    -> fexpand
    _              -> exitFailure


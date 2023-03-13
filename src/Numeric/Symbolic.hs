module Numeric.Symbolic where

import Numeric.Algebra hiding (zero)
import Prelude hiding ((+), (-), (*), (^), negate, (>), (<), sum, fromInteger)
import Data.List (intercalate)

--import Numeric.Extensive


-- A symbol represents a function, which is expected to be a real function of n
-- variables
data Function = F String Int

-- An expression represents something you can build up from the atomic fuctions
data Expression
  = Atomic Function
  | Mul [ Expression ]
  | Add [ Expression ]

instance Multiplicative Expression where
  (*) (Mul xs) (Mul ys) = Mul (xs <> ys)
  (*) (Mul xs) y = Mul (xs <> [y])
  (*) x (Mul ys) = Mul ([x] <> ys)
  (*) x y = Mul [x, y]

instance Additive Expression where
  (+) (Add xs) (Add ys) = Add (xs <> ys)
  (+) (Add xs) y = Add (xs <> [y])
  (+) x (Add ys) = Add ([x] <> ys)
  (+) x y = Add [x, y]

instance Show Expression where
  show (Atomic (F str _)) = str
  show (Mul xs) = intercalate ""    $ map showWithParen xs
  show (Add xs) = intercalate " + " $ map show xs

showWithParen :: Expression -> String
showWithParen (Add xs) = "(" <> show (Add xs) <> ")"
showWithParen m = show m

expand :: Expression -> Expression
expand (Atomic f) = Atomic f
expand (Add xs) = Add [ expand x | x <- xs ]
expand (Mul (x:xs)) = Add [ Mul (z:zs) | z <- expand x, zs <- expand xs ]
expand (Mul []) = Add []

--xs :: [[Int]]
--xs = [[1,2,3,4], [7,8], [10,11,12]]
--
--expand :: [[a]] -> [[a]]
--expand (y:ys) = [ z:zs | z <- y, zs <- expand ys]
--expand [] = [[]]

f,g,h :: Expression
f = Atomic (F "f" 1)
g = Atomic (F "g" 1)
h = Atomic (F "h" 1)

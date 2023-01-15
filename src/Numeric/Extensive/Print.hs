{-# LANGUAGE FlexibleInstances #-}
{-# OPTIONS_GHC -Wno-orphans #-}
module Numeric.Extensive.Print where

import Text.PrettyPrint.Boxes
import Text.Printf

import Numeric.Extensive.Core

dispInBasis :: Eq b => (b -> String) -> [b] -> T b -> String
dispInBasis disp bs v =
        let coef (T v') = v' . delta
            pairs = [ (e, coef v e) | e <- bs ]
            showPair (b, n)
               | n == " + 1" = " + "  ++ disp b
               | n == " - 1" = " - "  ++ disp b
               | otherwise   = n      ++ disp b
            showN (b, n') =
                let --n = (read $ printf "%0.5f" n' ) :: Double
                    n = n'
                    rn = round n :: Integer
                    i = n == fromInteger rn
                    sgn = if n > 0 then " + " else " - "
                    sn = if i then show (abs rn) else show (abs n)
                in (b, sgn ++ sn)
        in  case map (showPair . showN) . filter (\(_,n) -> n /= 0.0) $ pairs of
                  [] -> " 0"
                  ss -> concat ss


instance (Eq a, FiniteSet a, Show a) => Show (T a) where
    show = showInBasis elements

showInBasis :: (Show b, Eq b) => [b] -> T b -> String
showInBasis = dispInBasis show


instance (Eq a, FiniteSet a, Tex a) => Tex (T a) where
    tex = texInBasis elements

texInBasis :: (Tex b, Eq b) => [b] -> T b -> String
texInBasis = dispInBasis tex

mkBox :: (FiniteSet a, FiniteSet b, Eq b, Eq a)
      => T (Hom a b) -> Box
mkBox m = box
      where
        es = map return elements
        box = hsep 2 left cls
        cls = [ vsep 0 right (map (ts . snd) (coefficients (apply m e'))) | e' <- es]
        ts = text . printf "%0.4f"

printMap :: (FiniteSet a, FiniteSet b, Eq b, Eq a)
         =>  (T a -> T b) -> IO ()
printMap  = putStrLn . render . mkBox . hom
instance (FiniteSet a, FiniteSet b, Eq b, Eq a) => Show (T a -> T b) where
    show = render. mkBox . hom

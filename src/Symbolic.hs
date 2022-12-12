{-# LANGUAGE OverloadedStrings #-}
module Symbolic where

import Data.Text (Text)
import qualified Data.Text as Text
import Numeric.Algebra
import Prelude hiding ((+), (-), (*), (^), negate, (>), (<), sum, fromInteger)

-- Term represents a symbolic variable and a coefficient
data Term r
  = Term
  { coefficent :: r
  , symbol     :: Text
  }
  deriving Show

instance Multiplicative r => Multiplicative (Term r)
  where
    (Term x a) * (Term y b) = Term (x*y) (Text.concat [a, " ", b])


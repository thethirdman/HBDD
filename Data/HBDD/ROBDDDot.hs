module Data.HBDD.ROBDDDot
(
showDot
)
where

import Prelude hiding(lookup)
import Data.HBDD.ROBDD
import Data.HBDD.ROBDDContext

showDot :: (Ord v, Show v) => ROBDDContext v -> ROBDD v -> String
showDot context robdd = "digraph hbdd {"
                        ++ showDotLabel context robdd
                        ++ showDotLinks context robdd
                        ++ "}"

showDotLabel :: (Ord v, Show v) => ROBDDContext v -> ROBDD v -> String
showDotLabel context (ROBDD    l v r i) =
  show (identifier l) ++ show i ++ show (identifier r) ++
  "[label = " ++ show v ++ "];" ++ showDotLabel context l ++ showDotLabel context r
showDotLabel context (ROBDDRef l v r _) = showDotLabel context $ lookupUnsafe (l, v, r) context
showDotLabel _       Zero = "zero [shape = box];"
showDotLabel _       One  = "one [shape = box];"

showDotLinks :: (Ord v, Show v) => ROBDDContext v -> ROBDD v -> String
showDotLinks context (ROBDD    l _ r i) =
  show (identifier l ) ++ show i ++ show (identifier r)
    ++ " -> " ++ showDotLabel' l ++ "[style=dashed];" ++
  show (identifier l) ++ show i ++ show (identifier r)
  ++  " -> " ++ showDotLabel' r ++ ";"
  ++ showDotLinks context r ++ showDotLinks context l

showDotLinks context (ROBDDRef l v r _) = showDotLinks context $ lookupUnsafe (l, v, r) context
showDotLinks _ Zero = "zero;"
showDotLinks _ One  = "one;"


showDotLabel' :: (Ord v, Show v) => ROBDD v -> String
showDotLabel' Zero = "zero"
showDotLabel' One = "one"
showDotLabel' (ROBDD left v right id)=
  show (identifier left) ++ show id ++ show (identifier right)
showDotLabel' (ROBDDRef left _ right id)=
  show left ++ show id ++ show right
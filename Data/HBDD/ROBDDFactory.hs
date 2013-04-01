module Data.HBDD.ROBDDFactory
(
mkNode
, singleton
, singletonNot
)
where

import Prelude hiding(lookup)
import Data.HBDD.ROBDD
import Data.HBDD.ROBDDContext

mkNode :: Ord v => ROBDDContext v -> ROBDD v -> v -> ROBDD v -> (ROBDDContext v, ROBDD v)
mkNode context l v r = case lookup (ROBDDId idl v idr) context of
                       Just c  -> (context, ROBDDRef idl v idr $ identifier c)
                       Nothing ->
                         if idl == idr then
                          (context, l) -- If the left and right child are the same, no need to create a useless node
                         else
                           let (uid, ctx) = allocId context
                               res        = ROBDD l v r uid
                               ctx'       = insert (ROBDDId idl v idr) res ctx
                           in
                           (ctx', res)
                       where
                       idl = identifier l
                       idr = identifier r

singleton :: Ord v => ROBDDContext v -> v -> (ROBDDContext v, ROBDD v)
singleton context var = mkNode context Zero var One

singletonNot :: Ord v => ROBDDContext v -> v -> (ROBDDContext v, ROBDD v)
singletonNot context var = mkNode context One var Zero

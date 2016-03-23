module Redux.Reducer where

import Data.Function (Fn2, mkFn2)
import Data.Nullable (Nullable, toMaybe)
import Data.Maybe (Maybe(Just))

import Redux.Action (Action(Action))

type ReduxReducer action state = Fn2 (Nullable state) (Action action) state
type Reducer action state = action -> state -> state

foreign import applyReducer :: forall a s. Reducer a s -> a -> s -> s

reducer :: forall a s. Reducer a s -> s -> ReduxReducer a s
reducer f initialState =
  mkFn2 \state (Action action) ->
    case (toMaybe state) of
      (Just s)  -> applyReducer f action.type s
      otherwise -> initialState

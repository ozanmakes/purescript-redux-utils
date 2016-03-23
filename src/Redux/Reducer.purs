module Redux.Reducer
  ( Reducer()
  , ReduxReducer()
  , reducer
  ) where

import Prelude (($), (<<<))

import Data.Function (Fn2, mkFn2)
import Data.Nullable (Nullable, toMaybe)
import Data.Maybe (Maybe(Just))

import Redux.Action (Action(Action))

type Reducer action state = action -> state -> state
newtype ReduxReducer action state =
  ReduxReducer (Fn2 (Nullable state) (Action action) state)

foreign import applyReducer :: forall a s. Reducer a s -> a -> s -> s

-- | Construct a Redux reducer.
-- |
-- | Accepts a function, which takes an `Action` and returns a new state,
-- | and a value for the initial state.
-- |
-- | ```purescript
-- | counterImpl :: Reducer CounterAction Int
-- | counterImpl (Increment amount) n = n + amount
-- | counterImpl (Decrement amount) n = n - amount
-- |
-- | counter :: ReduxReducer CounterAction Int
-- | counter = reducer counterImpl 0
-- | ```
reducer :: forall a s. Reducer a s -> s -> ReduxReducer a s
reducer f initialState =
  ReduxReducer <<< mkFn2 $
  \state (Action action) ->
    case (toMaybe state) of
      (Just s) -> applyReducer f action.type s
      otherwise -> initialState

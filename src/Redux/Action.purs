module Redux.Action
  ( DISPATCH()
  , Action(..)
  , Dispatcher(..)
  , action
  , asyncAction
  , dispatch
  , getState
  ) where

import Prelude (class Show, Unit, pure, bind, show)

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Exception (EXCEPTION)
import Control.Monad.Aff (Aff, launchAff)
import Control.Monad.Reader.Trans (ReaderT, ask, reader, runReaderT)

import Data.Foreign (Foreign)
import Data.Function (Fn0, runFn0)
import Data.Tuple (Tuple(Tuple))

foreign import data DISPATCH :: !

newtype Action a =
  Action { "type" :: a }
instance showAction :: (Show a) => Show (Action a) where
  show (Action a) = show a.type

newtype Dispatcher a =
  Dispatcher (forall eff. Action a -> Eff (dispatch :: DISPATCH | eff) Unit)

type State = Foreign

type AsyncAction a r v = ReaderT (Tuple (Dispatcher a) (Fn0 State)) (Aff r) v

foreign import withToString :: forall a. (Show a) => a -> a

-- | Construct a pure Redux action.
action :: forall a. (Show a) => a -> Action a
action a = Action { "type": withToString a }

foreign import makeAsyncAction
  :: forall a eff.
     (Dispatcher a -> Fn0 State -> Eff eff Unit)
  -> Eff eff Unit

-- | Construct an asynchronous Redux action.
-- |
-- | You can use this to run async computations using Aff and dispatch pure
-- | actions based on the result.
-- |
-- | This method depends on `redux-thunk` middleware.
asyncAction
  :: forall a r.
     AsyncAction a (dispatch :: DISPATCH | r) Unit
  -> Eff (dispatch :: DISPATCH, err :: EXCEPTION | r) Unit
asyncAction a =
  makeAsyncAction
  \dispatch' getState' ->
    launchAff (runReaderT a (Tuple dispatch' getState'))

-- | Dispatch a pure Action within an Async Action.
-- |
-- | This is analogous to calling `store.dispatch()`
-- | inside a `redux-thunk` action.
dispatch
  :: forall a eff.
     Action a -> AsyncAction a (dispatch :: DISPATCH | eff) Unit
dispatch a =
  do (Dispatcher dispatch') <- reader get
     liftEff (dispatch' a)
  where get :: Tuple (Dispatcher a) (Fn0 State) -> (Dispatcher a)
        get (Tuple dispatcher _) = dispatcher

-- | Get the object containing current state tree.
-- |
-- | This is analogous to calling `store.getState()`
-- | inside a `redux-thunk` action.
getState :: forall a eff. AsyncAction a eff Foreign
getState =
  do t :: (Tuple (Dispatcher a) (Fn0 State)) <- ask
     pure (get t)
  where get :: Tuple (Dispatcher a) (Fn0 State) -> State
        get (Tuple _ getState') = runFn0 getState'

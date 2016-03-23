## Module Redux.Action

#### `DISPATCH`

``` purescript
data DISPATCH :: !
```

#### `Action`

``` purescript
newtype Action a
  = Action { type :: a }
```

##### Instances
``` purescript
(Show a) => Show (Action a)
```

#### `action`

``` purescript
action :: forall a. (Show a) => a -> Action a
```

Construct a pure Redux action.

#### `asyncAction`

``` purescript
asyncAction :: forall a r. AsyncAction a (dispatch :: DISPATCH | r) Unit -> Eff (dispatch :: DISPATCH, err :: EXCEPTION | r) Unit
```

Construct an asynchronous Redux action.

You can use this to run async computations using Aff and dispatch pure
actions based on the result.

This method depends on `redux-thunk` middleware.

#### `dispatch`

``` purescript
dispatch :: forall a eff. Action a -> AsyncAction a (dispatch :: DISPATCH | eff) Unit
```

Dispatch a pure Action within an Async Action.

This is analogous to calling `store.dispatch()`
inside a `redux-thunk` action.

#### `getState`

``` purescript
getState :: forall a eff. AsyncAction a eff Foreign
```

Get the object containing current state tree.

This is analogous to calling `store.getState()`
inside a `redux-thunk` action.



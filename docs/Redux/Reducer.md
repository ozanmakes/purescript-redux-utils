## Module Redux.Reducer

#### `Reducer`

``` purescript
type Reducer action state = action -> state -> state
```

#### `ReduxReducer`

``` purescript
newtype ReduxReducer action state
```

#### `reducer`

``` purescript
reducer :: forall a s. Reducer a s -> s -> ReduxReducer a s
```

Construct a Redux reducer.

Accepts a function, which takes an `Action` and returns a new state,
and a value for the initial state.

```purescript
counterImpl :: Reducer CounterAction Int
counterImpl (Increment amount) n = n + amount
counterImpl (Decrement amount) n = n - amount

counter :: ReduxReducer CounterAction Int
counter = reducer counterImpl 0
```

#### `combineReducers`

``` purescript
combineReducers :: forall a b c. {  | a } -> ReduxReducer b c
```



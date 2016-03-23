## Module Redux.Reducer

#### `ReduxReducer`

``` purescript
type ReduxReducer action state = Fn2 (Nullable state) (Action action) state
```

#### `Reducer`

``` purescript
type Reducer action state = action -> state -> state
```

#### `applyReducer`

``` purescript
applyReducer :: forall a s. Reducer a s -> a -> s -> s
```

#### `reducer`

``` purescript
reducer :: forall a s. Reducer a s -> s -> ReduxReducer a s
```



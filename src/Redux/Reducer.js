// module Redux.Reducer

var redux = require("redux")

exports.applyReducer = function (reducer) {
  return function (action) {
    return function (state) {
      try {
        state = reducer(action)(state)
      } catch (e) {
        if (!e.message.startsWith("Failed pattern match")) {
          throw e
        }
      }

      return state
    }
  }
}

exports.combineReducers = redux.combineReducers

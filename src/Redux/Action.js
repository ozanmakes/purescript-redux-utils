// module Redux.Action

exports.withToString = function (dictShow) {
  return function (action) {
    action.toString = function () {
      return dictShow.show(action)
    }

    return action
  }
}

exports.makeAsyncAction = function (actionCreator) {
  return function (dispatch, getState) {
    var _dispatch = function (action) {
      return function () {
        dispatch(action)
        return {}
      }
    }

    var _getState = function () {
      return getState()
    }

    actionCreator(_dispatch)(_getState)()
  }
}

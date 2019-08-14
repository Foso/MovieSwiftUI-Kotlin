package com.example.common

import com.example.common.state.AppState
import org.reduxkotlin.Dispatcher
import org.reduxkotlin.GetState
import org.reduxkotlin.Thunk
import org.reduxkotlin.createThunk

/**
 * Convenience function for creating thunks.
 * Usage:
 *      fun fetchStuff(id: String) = thunk { dispatch, getState, extraArgument ->
 *          api.fetchStuff()
 *      }
 */
fun thunk(thunkLambda: (dispatch: Dispatcher, getState: GetState<AppState>, extraArgument: Any?) -> Any): Thunk<AppState> =
    createThunk(thunkLambda)

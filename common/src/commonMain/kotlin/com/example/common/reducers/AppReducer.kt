package com.example.common.reducers

import com.example.common.state.AppState


fun appStateReducer(state: AppState, action: Any) : AppState = state.copy(moviesState = moviesStateReducer(state = state.moviesState, action = action),
        peoplesState = peoplesStateReducer(state.peoplesState, action))

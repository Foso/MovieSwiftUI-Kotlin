package com.example.common

import com.example.common.middlewares.loggingMiddleware
import com.example.common.models.CustomList
import com.example.common.models.sampleCasts
import com.example.common.models.sampleMovie
import com.example.common.reducers.appStateReducer
import com.example.common.state.AppState
import com.example.common.state.MoviesMenu
import com.example.common.state.MoviesState
import com.example.common.state.PeoplesState
import org.reduxkotlin.applyMiddleware
import org.reduxkotlin.createStore
import org.reduxkotlin.createThunkMiddleware

fun createStore() = createStore(
    ::appStateReducer, AppState(), applyMiddleware(
        createThunkMiddleware(),
        loggingMiddleware
    )
)

fun sampleCustomList() =
    CustomList(
        id = "0",
        name = "TestName",
        cover = "0",
        movies = mutableSetOf("0")
    )

fun createSampleStore() =
    createStore(
        ::appStateReducer,
        AppState(
            moviesState = MoviesState(
                movies = mutableMapOf("0" to sampleMovie),
                moviesList = mutableMapOf(MoviesMenu.popular to listOf("0")),
                recommended = mutableMapOf("0" to listOf("0")),
                similar = mutableMapOf("0" to listOf("0")),
                customLists = mutableMapOf("0" to sampleCustomList())
            ),
            peoplesState = PeoplesState(
                peoples = mutableMapOf(
                    "0" to sampleCasts().firstOrNull()!!,
                    "1" to sampleCasts()[1]
                ),
                peoplesMovies = mutableMapOf(),
                search = mutableMapOf()
            )
        )
    )

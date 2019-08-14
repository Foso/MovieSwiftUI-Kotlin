package com.example.common.view

import com.example.common.state.AppState
import org.reduxkotlin.Dispatcher

data class MovieGenreListProps(
    val movies: List<String>,
    val dispatcher: Dispatcher
) {

    fun props(genreId: String): PropsMapper<MovieGenreListProps> {
        fun map(state: AppState, dispatcher: Dispatcher): MovieGenreListProps {
            return MovieGenreListProps(movies = state.moviesState.withGenreId(genreId),
                dispatcher = dispatcher)
        }
        return ::map
    }
}

fun movieGenreProps(genreId: String): PropsMapper<MovieGenreListProps> {
    fun map(state: AppState, dispatcher: Dispatcher): MovieGenreListProps {
        return MovieGenreListProps(movies = state.moviesState.withGenreId(genreId),
            dispatcher = dispatcher)
    }
    return ::map
}
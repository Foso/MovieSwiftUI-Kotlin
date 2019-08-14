package com.example.common.models

import com.example.common.MoviesSort
import com.example.common.sortedMoviesIds
import com.example.common.state.AppState
import kotlinx.serialization.Serializable

@Serializable
data class CustomList(
    val id: String,
    var name: String,
    var cover: String? = null,
    var movies: MutableSet<String>
) {
    fun sortedMoviesIds(by: MoviesSort, state: AppState) = movies.sortedMoviesIds(by, state)
}

package com.example.common.view

import com.example.common.models.DiscoverFilter
import com.example.common.models.Genre
import com.example.common.models.Movie
import org.reduxkotlin.Dispatcher

data class DiscoverViewProps(
    val movies: List<String>,
    val posters: Map<String, String>,
    val currentMovie: Movie?,
    val filter: DiscoverFilter?,
    val genres: List<Genre>,
    val dispatch: Dispatcher
) {
    fun reversedMoviesFirstIndexOf(id: String): Int = movies.reversed().indexOfFirst { it == id }
    fun isLastMovieInList(id: String): Boolean = if (movies.isEmpty()) false else movies.last() == id
}


fun discoverViewPropsMapper(): PropsMapper<DiscoverViewProps> = { state, dispatch ->
    val posters = mutableMapOf<String, String>()
    val movies = state.moviesState.discover
    for (movie in movies) {
        val posterPath = state.moviesState.movies[movie]!!.poster_path
        if (posterPath != null)
            posters[movie] = posterPath
    }
    DiscoverViewProps(
        movies = movies,
        posters = posters,
        currentMovie = if (movies.isEmpty()) null else state.moviesState.movies[movies.reversed()[0]],
        filter = state.moviesState.discoverFilter,
        genres = state.moviesState.genres,
        dispatch = dispatch
    )

}

package com.example.common.reducers

import com.example.common.actions.MoviesActions
import com.example.common.actions.PeopleActions
import com.example.common.models.Genre
import com.example.common.models.Movie
import com.example.common.models.MovieUserMeta
import com.example.common.state.MoviesState
import com.soywiz.klock.DateTime


fun moviesStateReducer(state: MoviesState, action: Any) : MoviesState {
    var state = state
    when (action) {
        is MoviesActions.SetMovieMenuList -> {
            if (action.page == 1) {
                state.moviesList[action.list] = action.response.results.map { it.id }
            } else {
                var list = state.moviesList[action.list]
                if (list != null) {
                    list = list.plus(action.response.results.map { it.id })
                    state.moviesList[action.list] = list
                } else {
                    state.moviesList[action.list] = action.response.results.map { it.id }
                }
            }
            state.movies += action.response.results
        }
        is MoviesActions.SetDetail -> state.movies[action.movie] = action.response
        is MoviesActions.SetRecommended -> {
            state.recommended[action.movie] = action.response.results.map { it.id }
            state = mergeMovies(movies = action.response.results, state = state)
        }
        is MoviesActions.SetSimilar -> {
            state.similar[action.movie] = action.response.results.map { it.id }
            state = mergeMovies(movies = action.response.results, state = state)
        }
        is MoviesActions.SetSearch -> {
            if (action.page == 1) {
                state.search[action.query] = action.response.results.map { it.id }.toMutableList()
            } else {
                state.search[action.query]?.addAll(action.response.results.map { it.id })
            }
            state = mergeMovies(movies = action.response.results, state = state)
        }
        is MoviesActions.SetSearchKeyword -> state.searchKeywords[action.query] = action.response.results
        is MoviesActions.AddToWishlist -> {
            state.wishlist = state.wishlist.minus(action.movie)
            state.seenlist = state.wishlist.minus(action.movie)
            val meta = state.moviesUserMeta[action.movie] ?: MovieUserMeta()
            meta.addedToList = DateTime.now()
            state.moviesUserMeta[action.movie] = meta
        }
        is MoviesActions.RemoveFromWishlist -> state.wishlist = state.wishlist.minus(action.movie)
        is MoviesActions.AddToSeenList -> {
            state.seenlist = state.seenlist.plus(action.movie)
            state.wishlist = state.wishlist.minus(action.movie)
            val meta = state.moviesUserMeta[action.movie] ?: MovieUserMeta()
            meta.addedToList = DateTime.now()
            state.moviesUserMeta[action.movie] = meta
        }
        is MoviesActions.RemoveFromSeenList -> state.seenlist = state.seenlist.minus(action.movie)
        is MoviesActions.AddMovieToCustomList -> state.customLists[action.list]?.movies?.add(action.movie)
        is MoviesActions.AddMoviesToCustomList -> {
            val list = state.customLists[action.list]
            if (list != null) {
                for (movie in action.movies) {
                    list.movies.add(movie)
                }
                state.customLists[action.list] = list
            }
        }
        is MoviesActions.RemoveMovieFromCustomList -> state.customLists[action.list]?.movies?.remove(action.movie)
        is MoviesActions.SetMovieForGenre -> {
            if (action.page == 1) {
                state.withGenre[action.genre.id] = action.response.results.map { it.id }.toMutableList()
            } else {
                state.withGenre[action.genre.id]?.addAll(action.response.results.map { it.id })
            }
            state = mergeMovies(movies = action.response.results, state = state)
        }
        is MoviesActions.SetRandomDiscover -> {
            if (state.discover.isEmpty()) {
                state.discover = action.response.results.map { it.id }.toMutableList()
            } else if (state.discover.size < 10) {
                state.discover.addAll(0, action.response.results.map { it.id })
            }
            state = mergeMovies(movies = action.response.results, state = state)
            state.discoverFilter = action.filter
        }
        is MoviesActions.SetMovieReviews -> state.reviews[action.movie] = action.response.results
        is MoviesActions.SetMovieWithCrew -> {
            state.withCrew[action.crew] = action.response.results.map { it.id }
            state = mergeMovies(movies = action.response.results, state = state)
        }
        is MoviesActions.SetMovieWithKeyword -> {
            if (action.page == 1) {
                state.withKeywords[action.keyword] = action.response.results.map { it.id }.toMutableList()
            } else {
                state.withKeywords[action.keyword]?.addAll(action.response.results.map { it.id })
            }
            state = mergeMovies(movies = action.response.results, state = state)
        }
        is MoviesActions.AddCustomList -> state.customLists[action.list.id] = action.list
        is MoviesActions.EditCustomList -> {
            val list = state.customLists[action.list]
            if (list != null) {
                val cover = action.cover
                if (cover != null) {
                    list.cover = cover
                }
                val title = action.title
                if (title != null) {
                    list.name = title
                }
                state.customLists[action.list] = list
            }
        }
        is MoviesActions.RemoveCustomList -> state.customLists.remove(action.list)
        is MoviesActions.PopRandromDiscover -> state.discover.removeAt(state.discover.size - 1)
        is MoviesActions.PushRandomDiscover -> state.discover.add(action.movie)
        is MoviesActions.ResetRandomDiscover -> {
            state.discoverFilter = null
            state.discover = mutableListOf()
        }
        is MoviesActions.SetGenres -> {
            state.genres = action.genres.toMutableList()
            state.genres.add(0, Genre(id = "-1", name = "Random"))
        }
        is PeopleActions.SetPeopleCredits -> {
            val crews = action.response.crew
            if (crews != null) {
                state = mergeMovies(movies = crews, state = state)
            }
            val casts = action.response.cast
            if (casts != null) {
                state = mergeMovies(movies = casts, state = state)
            }
        }
        is MoviesActions.SaveDiscoverFilter -> state.savedDiscoverFilters.add(action.filter)
        is MoviesActions.ClearSavedDiscoverFilters -> state.savedDiscoverFilters = mutableListOf()
        else -> state
    }

    return state
}

operator fun MutableMap<String, Movie>.plusAssign(rhs: List<Movie>) {
    for (movie in rhs) {
        this[movie.id] = movie
    }
}

private fun mergeMovies(movies: List<Movie>, state: MoviesState) : MoviesState {
    val state = state
    for (movie in movies) {
        if (state.movies[movie.id] == null) {
            state.movies[movie.id] = movie
        }
    }
    return state
}

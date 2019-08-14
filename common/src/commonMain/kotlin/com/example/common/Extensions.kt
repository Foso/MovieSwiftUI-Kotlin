package com.example.common

import com.example.common.MoviesSort.*
import com.example.common.state.AppState
import com.soywiz.klock.DateTime

enum class MoviesSort(val title: String, val sortByAPI: String) {
    byReleaseDate("by release date", "release_date.asc"),
    byAddedDate("by added date", "primary_release_dat.desc"),
    byScore("by rating", "vote_average.desc"),
    byPopularity("by populartiy", "popularity.desc")
}

fun Collection<String>.sortedMoviesIds(by: MoviesSort, state: AppState): List<String> =
    when (by) {
        byAddedDate -> state.moviesState.moviesUserMeta
            .filter { contains(it.key) }
            .entries.sortedBy { it.value.addedToList ?: DateTime.now() > it.value.addedToList ?: DateTime.now() }
            .map { it.key }

        byReleaseDate -> state.moviesState.movies.filter { this.contains(it.key) }
            .entries.sortedBy { it.value.releaseDate > it.value.releaseDate }
            .map { it.key }

        byPopularity -> state.moviesState.movies.filter { this.contains(it.key) }
            .entries
            .sortedBy { it.value.popularity > it.value.popularity }
            .map { it.key }

        byScore -> state.moviesState.movies.filter { this.contains(it.key) }
            .entries.sortedBy { it.value.vote_average > it.value.vote_average }
            .map { it.key }
    }


package com.example.common.view

import com.example.common.MoviesSort
import com.example.common.models.CustomList
import com.example.common.sortedMoviesIds


data class MyListsProps(
    val customLists: List<CustomList>,
    val wishlist: List<String>,
    val seenlist: List<String>
)


fun myListsPropMapper(selectedMoviesSort: MoviesSort): PropsMapper<MyListsProps> =
    { state, _ ->
        MyListsProps(customLists = state.moviesState.customLists.values.toList(),
            wishlist = state.moviesState.wishlist.map { it }
                .sortedMoviesIds(
                    by = selectedMoviesSort,
                    state = state
                ),
            seenlist = state.moviesState.seenlist.map { it }.sortedMoviesIds(
                by = selectedMoviesSort,
                state = state
            )
        )
    }


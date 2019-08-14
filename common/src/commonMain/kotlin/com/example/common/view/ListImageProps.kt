package com.example.common.view

data class ListImageProps(
    val isInwishlist: Boolean,
    val isInSeenlist: Boolean,
    val isInCustomList: Boolean
)


fun listImapePropsMapper(movieId: String): PropsMapper<ListImageProps> = { state, _ ->
    ListImageProps(isInwishlist = state.moviesState.wishlist.contains(movieId),
        isInSeenlist = state.moviesState.seenlist.contains(movieId),
        isInCustomList = state.moviesState.customLists.filterValues {
            it.movies.contains(movieId)
        }.isNotEmpty()
    )
}



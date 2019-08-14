package com.example.common.state

import com.example.common.models.*

data class MoviesState(
    var movies: MutableMap<String, Movie> = mutableMapOf(),
    var moviesList: MutableMap<MoviesMenu, List<String>> = mutableMapOf(),
    var recommended: MutableMap<String, List<String>> = mutableMapOf(),
    var similar: MutableMap<String, List<String>> = mutableMapOf(),
    var search: MutableMap<String, MutableList<String>> = mutableMapOf(),
    var searchKeywords: MutableMap<String, List<Keyword>> = mutableMapOf(),
    var recentSearches: Set<String> = setOf(),
    var moviesUserMeta: MutableMap<String, MovieUserMeta> = mutableMapOf(),
    var discover: MutableList<String> = mutableListOf(),
    var discoverFilter: DiscoverFilter? = null,
    var savedDiscoverFilters: MutableList<DiscoverFilter> = mutableListOf(),
    var wishlist: Set<String> = setOf(),
    var seenlist: Set<String> = setOf(),
    var withGenre: MutableMap<String, MutableList<String>> = mutableMapOf(),
    var withKeywords: MutableMap<String, MutableList<String>> = mutableMapOf(),
    var withCrew: MutableMap<String, List<String>> = mutableMapOf(),
    var reviews: MutableMap<String, List<Review>> = mutableMapOf(),
    var customLists: MutableMap<String, CustomList> = mutableMapOf(),
    var genres: MutableList<Genre> = mutableListOf()
) {
    enum class CodingKeys(val rawValue: String) {
        movies("movies"),
        wishlist("wishlist"),
        seenlist("seenlist"),
        customLists("customLists"),
        moviesUserMeta(
            "moviesUserMeta"
        ),
        savedDiscoverFilters("savedDiscoverFilters");

        companion object {
            operator fun invoke(rawValue: String) =
                CodingKeys.values().firstOrNull { it.rawValue == rawValue }
        }
    }

    fun withMovieId(movieId: String): Movie = movies[movieId]!!

    fun withCrewId(crewId: String) = withCrew[crewId] ?: listOf()

    fun withListId(listId: String) = customLists[listId]

    fun withKeywordId(keywordId: String) = withKeywords[keywordId]!!.toList()

    fun withGenreId(genreId: String): List<String> = withGenre[genreId] ?: listOf()

    fun getGenreById(genreId: String) = genres.find { it.id == genreId }

    fun search(searchText: String) = search[searchText]?.toList()

    val customListsList: List<CustomList>
        get() = customLists.values.toList()

    fun reviewByMovieId(movieId: String): List<Review>? = reviews[movieId]


    fun recommendedMovies(movieId: String): List<Movie>? = recommended[movieId]?.filter { movies.containsKey(it) }?.mapNotNull { movies[it] }

    fun similarMovies(movieId: String): List<Movie>? = similar[movieId]?.filter { movies.containsKey(it) }?.mapNotNull { movies[it] }
}
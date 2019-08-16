package com.example.common.services


enum class ImageUrl(private val baseUrl: String) {
    small("https://image.tmdb.org/t/p/w154"),
    medium("https://image.tmdb.org/t/p/w500"),
    cast("https://image.tmdb.org/t/p/w185"),
    original("https://image.tmdb.org/t/p/original");

    fun path(poster: String): String = baseUrl + poster
}

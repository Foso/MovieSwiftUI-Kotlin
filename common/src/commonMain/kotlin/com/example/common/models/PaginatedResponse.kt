package com.example.common.models

import kotlinx.serialization.Serializable


interface PaginatedResponse<T> {
    val page: Int?
    val total_results: Int?
    val total_pages: Int?
    val results: List<T>
}

@Serializable
data class MoviePaginatedResponse(
    override val page: Int,
    override val total_results: Int?,
    override val total_pages: Int?,
    override val results: List<Movie>
): PaginatedResponse<Movie>

@Serializable
data class GenrePaginatedResponse(
    override val page: Int,
    override val total_results: Int?,
    override val total_pages: Int?,
    override val results: List<Genre>
): PaginatedResponse<Genre>

@Serializable
data class PeoplePaginatedResponse(
    override val page: Int,
    override val total_results: Int?,
    override val total_pages: Int?,
    override val results: List<People>
): PaginatedResponse<People>

@Serializable
data class ReviewPaginatedResponse(
    override val page: Int,
    override val total_results: Int?,
    override val total_pages: Int?,
    override val results: List<Review>
): PaginatedResponse<Review>

@Serializable
data class KeywordPaginatedResponse(
    override val page: Int,
    override val total_results: Int?,
    override val total_pages: Int?,
    override val results: List<Keyword>
): PaginatedResponse<Keyword>

package com.example.common.models

import kotlinx.serialization.Serializable

@Serializable
data class Review(
    val id: String,
    val author: String,
    val content: String
)

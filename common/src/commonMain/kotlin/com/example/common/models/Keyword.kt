package com.example.common.models

import kotlinx.serialization.Serializable


@Serializable
data class Keyword(
    val id: String,
    val name: String
)

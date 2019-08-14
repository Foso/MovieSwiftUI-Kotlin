package com.example.common.models

import kotlinx.serialization.Serializable


@Serializable
data class People(
    val id: String,
    val name: String,
    var character: String? = null,
    var department: String? = null,
    val profile_path: String? = null,
    val known_for_department: String? = null,
    var known_for: List<KnownFor>? = null,
    val also_known_as: List<String>? = null,
    val birthDay: String? = null,
    val deathDay: String? = null,
    val place_of_birth: String? = null,
    val biography: String? = null,
    val popularity: Double? = null,
    var images: List<ImageData>? = null
) {

    @Serializable
    data class KnownFor(
        val id: String,
        val original_title: String? = null,
        val poster_path: String? = null
    )
}

val People.knownForText: String?
    get() {
        val knownFor = known_for ?: return null
        val names = knownFor.filter { it.original_title != null }.map { it.original_title!! }
        return names.joinToString(separator = ", ")
    }

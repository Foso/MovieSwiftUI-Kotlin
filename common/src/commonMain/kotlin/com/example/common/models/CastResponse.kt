package com.example.common.models

import kotlinx.serialization.Serializable

@Serializable
data class CastResponse(
    val id: Int,
val cast: List<People>,
val crew: List<People>)

fun sampleCasts() =
    listOf(
        People(
            id = "0",
            name = "Cast 1",
            character = "Character 1",
            department = null,
            profile_path = "/2daC5DeXqwkFND0xxutbnSVKN6c.jpg",
            known_for_department = "Acting",
            known_for = listOf(
                People.KnownFor(
                    id = sampleMovie.id,
                    original_title = sampleMovie.original_title,
                    poster_path = sampleMovie.poster_path
                )
            ),
            also_known_as = null,
            birthDay = null,
            deathDay = null,
            place_of_birth = null,
            biography = null,
            popularity = null,
            images = null
        ),
        People(
            id = "1",
            name = "Cast 2",
            character = null,
            department = "Director 1",
            profile_path = "/2daC5DeXqwkFND0xxutbnSVKN6c.jpg",
            known_for_department = "Acting",
            known_for = null,
            also_known_as = null,
            birthDay = null,
            deathDay = null,
            place_of_birth = null,
            biography = null,
            popularity = null,
            images = null
        )
    )

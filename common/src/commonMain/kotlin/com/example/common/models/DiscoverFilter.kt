package com.example.common.models

import com.soywiz.klock.DateTime
import kotlinx.serialization.Serializable
import kotlin.random.Random
import kotlin.random.nextInt


@Serializable
data class DiscoverFilter(
    val year: Int,
    val startYear: Int?,
    val endYear: Int?,
    val sort: String,
    val genre: String?,
    val region: String?
) {
    companion object {

        private fun random() = Random(DateTime.now().unixMillisLong)

        fun randomFilter(): DiscoverFilter =
            DiscoverFilter(
                year = randomYear(),
                startYear = null,
                endYear = null,
                sort = randomSort(),
                genre = null,
                region = null
            )

        fun randomYear(): Int = random().nextInt(range = 1950 until DateTime.now().yearInt)

        fun randomSort(): String {
            val sortBy =
                listOf("popularity.desc", "popularity.asc", "vote_average.asc", "vote_average.desc")
            return sortBy[random().nextInt(range = sortBy.indices)]
        }

        fun randomPage(): Int = random().nextInt(1, until = 20)
    }


    fun toParams(): Map<String, String> {
        var params = mutableMapOf<String, String>()
        val startYear = startYear
        val endYear = endYear
        if (startYear != null && endYear != null) {
            params["primary_release_date.gte"] = "${startYear}"
            params["primary_release_date.lte"] = "${endYear}"
        } else {
            params["year"] = "${year}"
        }
        val genre = genre
        if (genre != null) {
            params["with_genres"] = "${genre}"
        }
        val region = region
        if (region != null) {
            params["region"] = region
        }
        params["page"] = "${DiscoverFilter.randomPage()}"
        params["sort_by"] = sort
        params["language"] = "en-US"
        return params
    }

    fun toText(genres: List<Genre>): String {
        var text = String()
        val startYear = startYear
        val endYear = endYear
        if (startYear != null && endYear != null) {
            text += "$startYear-$endYear"
        } else {
            text = "$text · Random"
        }
        val genre = genre
        val stateGenre = genres.firstOrNull { realGenre ->
            realGenre.id == genre
        }
        if (genre != null && stateGenre != null) text += " · ${stateGenre.name}"
        val region = region
        if (region != null) {
            text += " · $region"
        }
        return text
    }
}

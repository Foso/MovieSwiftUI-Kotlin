package com.example.common.state

import com.example.common.models.People

data class PeoplesState(
    var peoples: MutableMap<String, People> = mutableMapOf(),
    var peoplesMovies: MutableMap<String, List<String>> = mutableMapOf(),
    var search: MutableMap<String, List<String>> = mutableMapOf(),
    var popular: List<String> = listOf(),
/// [PeopleId: [MovieId:  Character]]
    var casts: MutableMap<String, MutableMap<String, String>> = mutableMapOf(),
/// [PeopleId: [MovieId:  Character]]
    var crews: MutableMap<String, MutableMap<String, String>> = mutableMapOf(),
    var fanClub: Set<String> = setOf()
) {
    enum class CodingKeys(val rawValue: String) {
        peoples("peoples"),
        fanClub("fanClub");

        companion object {
            operator fun invoke(rawValue: String) =
                CodingKeys.values().firstOrNull { it.rawValue == rawValue }
        }
    }

    fun crewsByPeopleId(peopleId: String): Map<String, String> = crews[peopleId] ?: mapOf()

    fun castsByPeopleId(peopleId: String): Map<String, String> = casts[peopleId] ?: mapOf()

    fun withPeopleId(peopleId: String) = peoples[peopleId]

    fun filterPeoples(predicate: (People) -> Boolean) = peoples.values.filter(predicate)

    val characters
        get() = peoples.values.filter { it.character != null }

    val credits
        get() = peoples.values.filter { it.department != null }

}
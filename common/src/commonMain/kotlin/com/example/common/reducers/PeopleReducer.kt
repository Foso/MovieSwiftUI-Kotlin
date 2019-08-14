package com.example.common.reducers

import com.example.common.actions.PeopleActions
import com.example.common.models.People
import com.example.common.state.PeoplesState


fun peoplesStateReducer(state: PeoplesState, action: Any): PeoplesState {
    var state = state
    when (action) {
        is PeopleActions.SetMovieCasts -> {
            state = mergePeople(peoples = action.response.cast, state = state)
            state = mergePeople(peoples = action.response.crew, state = state)
            state.peoplesMovies[action.movie] =
                action.response.cast.map { it.id } + action.response.crew.map { it.id }
        }
        is PeopleActions.SetSearch -> {
            if (action.page == 1) {
                state.search[action.query] = action.response.results.map { it.id }
            } else {
                state.search[action.query] =
                    state.search[action.query]!!.plus(action.response.results.map { it.id })
            }
            state = mergePeople(peoples = action.response.results, state = state)
        }
        is PeopleActions.SetPopular -> {
            if (action.page == 1) {
                state.popular = action.response.results.map { it.id }
            } else {
                state.popular = state.popular.plus(action.response.results.map { it.id })
            }
            state = mergePeople(peoples = action.response.results, state = state)
        }
        is PeopleActions.SetDetail -> {
            val current = state.peoples[action.person.id]
            if (current != null) {
                var new = action.person
                new.known_for = current.known_for
                new.images = current.images
                new.character = current.character
                new.department = current.department
                state.peoples[action.person.id] = new
            } else {
                state.peoples[action.person.id] = action.person
            }
        }
        is PeopleActions.SetPeopleCredits -> {
            val cast = action.response.cast
            if (cast != null) {
                if (state.casts[action.people] == null) {
                    state.casts[action.people] = mutableMapOf()
                }
                for (meta in cast) {
                    if (meta.character != null) {
                        state.casts[action.people]!![meta.id] = meta.character!!
                    }
                }
            }
            val crew = action.response.crew
            if (crew != null) {
                if (state.crews[action.people] == null) {
                    state.crews[action.people] = mutableMapOf()
                }
                for (meta in crew) {
                    if (meta.department != null) {
                        state.crews[action.people]!![meta.id] = meta.department!!
                    }
                }
            }
        }
        is PeopleActions.SetImages -> state.peoples[action.people]?.images = action.images
        is PeopleActions.AddToFanClub -> state.fanClub = state.fanClub.plus(action.people)
        is PeopleActions.RemoveFromFanClub -> state.fanClub = state.fanClub.minus(action.people)
        else -> state
    }
    return state
}

private fun mergePeople(peoples: List<People>, state: PeoplesState): PeoplesState {
    val state = state
    for (people in peoples) {
        if (state.peoples[people.id] == null) {
            state.peoples[people.id] = people
        }
    }
    return state
}

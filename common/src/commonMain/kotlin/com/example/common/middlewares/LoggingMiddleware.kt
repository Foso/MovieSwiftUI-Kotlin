package com.example.common.middlewares

import com.example.common.state.AppState
import com.github.aakira.napier.Napier
import org.reduxkotlin.Middleware

val loggingMiddleware: Middleware<AppState> = { store ->
    { next ->
        { action ->
            Napier.d("***************************************")
            Napier.d("Action: ${action::class.simpleName}")
            Napier.d("***************************************")
            next(action)
        }
    }

}
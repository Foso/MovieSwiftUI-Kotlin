package com.example.common.middlewares

import com.example.common.state.AppState
import ru.pocketbyte.hydra.log.HydraLog
import org.reduxkotlin.Middleware
import ru.pocketbyte.hydra.log.info

val loggingMiddleware: Middleware<AppState> = { store ->
    { next ->
        { action ->
            HydraLog.info("***************************************")
            HydraLog.info("Action: ${action::class.simpleName}")
            HydraLog.info("***************************************")
            next(action)
        }
    }

}
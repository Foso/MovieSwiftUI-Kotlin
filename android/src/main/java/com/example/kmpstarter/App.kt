package com.example.kmpstarter

import android.app.Application
import com.example.common.actions.MoviesActions
import com.example.common.createStore
import com.example.common.preferences.AppUserDefaults
import com.example.common.preferences.settings
import com.example.common.services.APIService
import com.github.aakira.napier.DebugAntilog
import com.github.aakira.napier.Napier
import kotlinx.coroutines.Dispatchers

val store = createStore()
lateinit var movieActions: MoviesActions

class App: Application() {
    private val apiService = APIService(Dispatchers.IO)
    private val appUserDefaults = AppUserDefaults(settings(this))

    override fun onCreate() {
        super.onCreate()
        Napier.base(DebugAntilog())
        movieActions = MoviesActions(apiService, appUserDefaults)
    }
}
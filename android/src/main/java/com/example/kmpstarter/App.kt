package com.example.kmpstarter

import android.app.Application
import com.example.common.actions.MoviesActions
import com.example.common.createStore
import com.example.common.preferences.AppUserDefaults
import com.example.common.preferences.settings
import com.example.common.services.APIService
import kotlinx.coroutines.Dispatchers

val store = createStore()
lateinit var movieActions: MoviesActions

class App: Application() {
    private val apiService = APIService(Dispatchers.IO)
    private lateinit var appUserDefaults: AppUserDefaults

    override fun onCreate() {
        super.onCreate()
        appUserDefaults = AppUserDefaults(settings(this))
        movieActions = MoviesActions(apiService, appUserDefaults)
    }
}
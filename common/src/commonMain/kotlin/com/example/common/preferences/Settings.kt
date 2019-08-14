package com.example.common.preferences

import com.russhwolf.settings.Settings
import com.russhwolf.settings.set

expect fun settings(context: Any? = null): Settings

class AppUserDefaults(private val settings: Settings) {
    private val REGION_KEY = "region"
    private val ALWAYS_ORIGINAL_TITLE_KEY = "alwaysOriginalTitle"

    var region: String
        get() = settings.getString(REGION_KEY, "US")
        set(value) {
            settings[REGION_KEY] = value
        }

    var alwaysOriginalTitle: Boolean
        get() = settings.getBoolean(ALWAYS_ORIGINAL_TITLE_KEY, false)
        set(value) {
            settings[ALWAYS_ORIGINAL_TITLE_KEY] = value
        }
}

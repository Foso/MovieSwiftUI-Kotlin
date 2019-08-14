package com.example.common.preferences

import android.content.Context
import com.russhwolf.settings.AndroidSettings
import com.russhwolf.settings.Settings

actual fun settings(context: Any?): Settings =
    AndroidSettings((context as Context).getSharedPreferences("settings", Context.MODE_PRIVATE))

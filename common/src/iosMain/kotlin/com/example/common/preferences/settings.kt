package com.example.common.preferences

import com.russhwolf.settings.AppleSettings
import com.russhwolf.settings.Settings
import platform.Foundation.NSUserDefaults

actual fun settings(context: Any?): Settings = AppleSettings(NSUserDefaults.standardUserDefaults)

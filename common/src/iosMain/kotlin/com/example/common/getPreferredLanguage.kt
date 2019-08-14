package com.example.common

import platform.Foundation.NSBundle

actual fun getPreferredLanguage(): String =
    NSBundle.mainBundle.preferredLocalizations.firstOrNull().let { it as? String ?: "en" }.substringBefore('-')

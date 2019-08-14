package com.example.common

private val javaLocale get() = java.util.Locale.getDefault()

actual fun getPreferredLanguage(): String = javaLocale.language.substringBefore('-')

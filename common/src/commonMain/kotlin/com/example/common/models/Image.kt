package com.example.common.models

import com.benasher44.uuid.Uuid
import kotlinx.serialization.Serializable
import kotlinx.serialization.Transient


@Serializable
data class ImageData(
    @Transient
    val id: Uuid = Uuid(),
    val aspect_ratio: Float,
    val file_path: String,
    val height: Int,
    val width: Int
)

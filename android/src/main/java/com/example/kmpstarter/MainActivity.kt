package com.example.kmpstarter

import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.os.Build
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.compose.*
import androidx.compose.frames.commit
import androidx.compose.frames.inFrame
import androidx.compose.frames.open
import androidx.ui.core.Text
import androidx.ui.core.dp
import androidx.ui.core.setContent
import androidx.ui.foundation.ColoredRect
import androidx.ui.foundation.SimpleImage
import androidx.ui.graphics.Color
import androidx.ui.graphics.ColorSpace
import androidx.ui.layout.*
import androidx.ui.material.*
import androidx.ui.painting.*
import coil.Coil
import coil.api.get
import com.example.common.helloWordText
import com.example.common.models.Movie
import com.example.common.services.ImageUrl
import com.example.common.state.AppState
import com.example.common.state.MoviesMenu
import kotlinx.android.synthetic.main.activity_main.*
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import org.reduxkotlin.Store
import org.reduxkotlin.StoreSubscriber

@Model
class CurrentMaterialColors {
    var colors = MaterialColors()
}

val dividerColor = Color(0xFFC6C6C6.toInt())

// effect-based API to select/subscribe to store in composition
fun <TSlice, TState> Store<TState>.select(selector: (TState) -> TSlice) = effectOf<TSlice> {
    val result = +state { selector(state) }
    +onCommit(selector) {
        val observer = {
            CoroutineScope(Dispatchers.Main).launch {
                val newState = selector(state)
                if (result != newState && inFrame) {
                    result.value = selector(state)
                }
            }
            Unit
        }
        val unsubscribe = subscribe(observer)
        onDispose {
            unsubscribe()
        }
    }
    result.value
}

class MainActivity : AppCompatActivity() {

    private val currentColors = CurrentMaterialColors()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            MaterialTheme(currentColors.colors) {
                HomeView()
            }
        }
        store.dispatch(movieActions.fetchMoviesMenuList(list = MoviesMenu.nowPlaying, page = 1))
        store.dispatch(movieActions.fetchGenres())
    }
}

@Composable
fun HomeView() {
    VerticalScroller {
        Column {
            val movies = +store.select { it.moviesState.movies.values.toList() }
            Text("Now showing")
            movies.forEachIndexed { index, movie ->
                Item(movie = movie)
                if (index != movies.size - 1) {
                    Divider(color = dividerColor, indent = ItemSize)
                }
            }
        }
    }
}


@Composable
fun Item(movie: Movie) {
    val image: State<Drawable?> = +state { null as Drawable? }
    GlobalScope.launch {
        val filePath = movie.poster_path
        if (filePath != null) {
            val url = ImageUrl.medium.path(filePath)
            val drawable = Coil.get(url)
            CoroutineScope(Dispatchers.Main).launch {
                image.value = drawable
            }
        }
    }
    val textStyle = +themeTextStyle { body1 }
    Row(crossAxisAlignment = CrossAxisAlignment.Center) {
        if (image.value != null) {
            SimpleImage(AndroidImage((image.value!! as BitmapDrawable).bitmap))
        }
        Text(text = movie.title, style = textStyle)
    }
}

private val ItemSize = 55.dp
private val ItemPadding = 7.5.dp

internal class AndroidImage(val bitmap: Bitmap) : Image {

    /**
     * @see Image.width
     */
    override val width: Int
        get() = bitmap.width

    /**
     * @see Image.height
     */
    override val height: Int
        get() = bitmap.height

    override val config: ImageConfig
        get() = ImageConfig.Argb8888

    /**
     * @see Image.colorSpace
     */
    override val colorSpace: ColorSpace
        get() = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            ColorSpace.get(ColorSpace.Named.Aces)//bitmap.colorSpace?.toComposeColorSpace() ?: ColorSpace.Named.Srgb.colorSpace
        } else {
            ColorSpace.get(ColorSpace.Named.Aces)
//            ColorSpace.Named.Srgb.colorSpace
        }

    /**
     * @see Image.hasAlpha
     */
    override val hasAlpha: Boolean
        get() = bitmap.hasAlpha()

    /**
     * @see Image.nativeImage
     */
    override val nativeImage: NativeImage
        get() = bitmap

    /**
     * @see
     */
    override fun prepareToDraw() {
        bitmap.prepareToDraw()
    }
}
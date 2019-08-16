package com.example.kmpstarter

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.ui.core.Text
import androidx.ui.core.setContent
import com.example.common.helloWordText
import kotlinx.android.synthetic.main.activity_main.*


class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
//        setContentView(R.layout.activity_main)
//        tv_message.text = helloWordText

        setContent {
            Text("HelloWorld")
        }
        store.dispatch(movieActions.fetchGenres())
    }
}

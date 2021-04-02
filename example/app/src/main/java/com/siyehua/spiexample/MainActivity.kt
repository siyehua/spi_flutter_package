package com.siyehua.spiexample

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import com.siyehua.spiexample.channel.ChannelManager

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        findViewById<View>(R.id.tv_content).setOnClickListener {
            startActivity(Intent(this, MainActivity2::class.java))
        }
    }
}
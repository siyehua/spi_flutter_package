package com.siyehua.spiexample;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;

import com.siyehua.spiexample.channel.ChannelManager;
import com.siyehua.spiexample.channel.flutter2native.IAccount;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;

public class MainActivity2 extends FlutterActivity {

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        ChannelManager.init(flutterEngine.getDartExecutor());
        ChannelManager.addChannelImpl(IAccount.class, new AccountImpl());
        super.configureFlutterEngine(flutterEngine);
    }
}
package com.siyehua.spiexample;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import com.siyehua.spiexample.channel.ChannelManager;
import com.siyehua.spiexample.channel.flutter2native.IAccount;
import com.siyehua.spiexample.channel.native2flutter.Fps;
import com.siyehua.spiexample.channel.native2flutter.Fps2;

import java.util.HashMap;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;

public class MainActivity2 extends FlutterActivity {

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        ChannelManager.init(flutterEngine.getDartExecutor());
        ChannelManager.addChannelImpl(IAccount.class, new AccountImpl());
        native2Flutter();
    }

    private void native2Flutter() {
        new Thread() {
            @Override
            public void run() {
                super.run();
                try {
                    Thread.sleep(15000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        testMethod();
                    }
                });
            }

        }.start();
    }

    private void testMethod() {
        ChannelManager.getChannel(Fps2.class).getFps(" native fps str", new ChannelManager.Result<Double>() {
            @Override
            public void success(@Nullable Double result) {
                Log.e("android", "getFps method:" + result + "");
            }

            @Override
            public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
                Log.e("android", "getFps method:" + errorCode + ": " + errorMessage);

            }

            @Override
            public void notImplemented() {

            }
        });
        HashMap<String, Long> data = new HashMap<>();
        data.put("nativekey", 100L);
        ChannelManager.getChannel(Fps2.class).getPageName(data, new ChannelManager.Result<String>() {
            @Override
            public void success(@Nullable String result) {
                Log.e("android", "getPageName method:" + result + "");
            }

            @Override
            public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
                Log.e("android", "getPageName method:" + errorCode + ": " + errorMessage);
            }

            @Override
            public void notImplemented() {

            }
        });
        ChannelManager.getChannel(Fps.class).add11(10086L);
    }
}
package com.siyehua.flutter_app;

import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.siyehua.example.chanel2.flutter2native.IPhoto;
import com.siyehua.example.chanel3.native2flutter.IPhoto2;
import com.siyehua.spiexample1.channel.ChannelManager;
import com.siyehua.spiexample1.channel.flutter2native.IAccount;
import com.siyehua.spiexample1.channel.flutter2native.InnerClass;
import com.siyehua.spiexample1.channel.native2flutter.Fps;
import com.siyehua.spiexample1.channel.native2flutter.Fps2;
import com.siyehua.spiexample1.channel.native2flutter.PageInfo;
import com.alibaba.fastjson.JSON;

import java.util.ArrayList;
import java.util.HashMap;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;

public class MainActivity extends FlutterActivity {

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        com.siyehua.example.chanel2.ChannelManager.init(flutterEngine.getDartExecutor(), new  com.siyehua.example.chanel2.ChannelManager.JsonParse() {
            @Nullable
            @Override
            public String toJSONString(@Nullable Object object) {
                return JSON.toJSONString(object);
            }

            @Nullable
            @Override
            public <T> T parseObject(@Nullable String text, @NonNull Class<T> clazz) {
                return JSON.parseObject(text, clazz);
            }
        });
        com.siyehua.example.chanel3.ChannelManager.init(flutterEngine.getDartExecutor(), new  com.siyehua.example.chanel3.ChannelManager.JsonParse() {
            @Nullable
            @Override
            public String toJSONString(@Nullable Object object) {
                return JSON.toJSONString(object);
            }

            @Nullable
            @Override
            public <T> T parseObject(@Nullable String text, @NonNull Class<T> clazz) {
                return JSON.parseObject(text, clazz);
            }
        });
        com.siyehua.example.chanel2.ChannelManager.addChannelImpl(IPhoto.class, new PhotoImpl());
        ChannelManager.init(flutterEngine.getDartExecutor(), new ChannelManager.JsonParse() {
            @Nullable
            @Override
            public String toJSONString(@Nullable Object object) {
                return JSON.toJSONString(object);
            }

            @Nullable
            @Override
            public <T> T parseObject(@Nullable String text, @NonNull Class<T> clazz) {
                return JSON.parseObject(text, clazz);
            }
        });
        ChannelManager.addChannelImpl(IAccount.class, new AccountImpl());
        native2Flutter();
    }

    private void native2Flutter() {
        new Thread() {
            @Override
            public void run() {
                super.run();
                try {
                    Thread.sleep(5000);
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
        com.siyehua.example.chanel3.ChannelManager.getChannel(IPhoto2.class).aaa();

        ChannelManager.getChannel(Fps2.class).getFps(" native fps str", 100L, new ChannelManager.Result<Double>() {
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
        ChannelManager.getChannel(Fps2.class).getPageName(data, "second params", new ChannelManager.Result<String>() {
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
        ChannelManager.getChannel(Fps.class).getPage(new ChannelManager.Result<PageInfo>() {
            @Override
            public void success(@Nullable PageInfo result) {
                Log.e("android", "getPage:" + JSON.toJSONString(result) + "");
            }

            @Override
            public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
                Log.e("android", "getPage method:" + errorCode + ": " + errorMessage);
            }

            @Override
            public void notImplemented() {

            }
        });
        ArrayList<Long> a = new ArrayList<>();
        a.add(18L);
        a.add(19L);
//        InnerClass innerClass = new InnerClass();
//        innerClass.a = "str from native";
//        innerClass.b = 18L;
//        a.add(innerClass);
        ChannelManager.getChannel(Fps.class).getListCustom(a, new ChannelManager.Result<ArrayList<PageInfo>>() {

            @Override
            public void success(@Nullable ArrayList<PageInfo> result) {
                Log.e("android", "getListCustom:" + JSON.toJSONString(result) + "");

            }

            @Override
            public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
                Log.e("android", "getListCustom method:" + errorCode + ": " + errorMessage);

            }

            @Override
            public void notImplemented() {

            }
        });

    }
}
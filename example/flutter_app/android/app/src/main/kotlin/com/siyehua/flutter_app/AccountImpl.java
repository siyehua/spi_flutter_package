package com.siyehua.flutter_app;

import android.util.Log;

import com.alibaba.fastjson.JSON;
import com.siyehua.spiexample.channel.ChannelManager;
import com.siyehua.spiexample.channel.flutter2native.IAccount;
import com.siyehua.spiexample.channel.flutter2native.InnerClass;

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;

public class AccountImpl implements IAccount {
    @Override
    public void getAge(@NotNull ChannelManager.Result<Long> callback) {
        callback.success(100L);
    }

    @Override
    public void getAge2(ChannelManager.Result<InnerClass> callback) {
    }

    @Override
    public void login(@Nullable String name, @NotNull Object password, @NotNull ChannelManager.Result<String> callback) {
        new Thread() {
            @Override
            public void run() {
                super.run();
                Log.e("android", "login method:" + name + ", password:" + password);
                try {
                    Thread.sleep(3000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                Log.e("android", "login method: callback success: true");
                callback.success("login success form native");
            }
        }.start();
    }

    @Override
    public void getToken(ChannelManager.Result<String> callback) {
        callback.success("your token is 9527 form naive");
    }

    @Override
    public void logout(@NotNull InnerClass abc, @NotNull ArrayList<InnerClass> list, @NotNull ArrayList<ArrayList<HashMap<Long, String>>> aaa) {
        Log.e("android", "logout method, nothing should call back:" + JSON.toJSONString(abc));
        Log.e("android", "logout method, nothing should call back:" + JSON.toJSONString(list));
        Log.e("android", "logout method, nothing should call back:" + JSON.toJSONString(aaa));
    }

    @Override
    public void getList(@Nullable InnerClass abc, @NotNull ChannelManager.Result<ArrayList<String>> callback) {
        ArrayList<String> data = new ArrayList<>();
        data.add("user");
        data.add("name");
        data.add("is");
        data.add("big boss");
        callback.success(data);
    }

    @Override
    public void getMap(@NotNull ChannelManager.Result<HashMap<ArrayList<String>, InnerClass>> callback) {
        HashMap<ArrayList<String>, InnerClass> data = new HashMap<>();
        ArrayList<String> key1 = new ArrayList<>();
        key1.add("key1");
        ArrayList<String> key2 = new ArrayList<>();
        key2.add("key2");
        InnerClass innerClass = new InnerClass();
        innerClass.a = "innercalss";
        innerClass.b = 18L;
        data.put(key1, innerClass);
        data.put(key2, innerClass);
        callback.success(data);
    }

    @Override
    public void setMap(HashMap<Long, Boolean> a) {
        Log.e("android", "data from flutter:" + Arrays.toString(a.values().toArray()));
    }

    @Override
    public void all(ArrayList<Long> a, HashMap<String, Long> b, Long c, ChannelManager.Result<HashMap<Long, Boolean>> callback) {
        Log.e("android", "data from flutter:" + Arrays.toString(a.toArray()));
        Log.e("android", "data from flutter:" + Arrays.toString(b.keySet().toArray()));
        Log.e("android", "data from flutter:" + Arrays.toString(b.values().toArray()));
        HashMap<Long, Boolean> data = new HashMap<>();
        data.put(1L, false);
        data.put(2L, true);
        callback.success(data);

    }


}

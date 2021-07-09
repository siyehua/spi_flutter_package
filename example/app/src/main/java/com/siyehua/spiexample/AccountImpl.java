package com.siyehua.spiexample;

import android.util.Log;

import com.siyehua.spiexample.channel.ChannelManager;
import com.siyehua.spiexample.channel.flutter2native.IAccount;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

public class AccountImpl implements IAccount {
    @Override
    public void login(String name, String password, ChannelManager.Result<String> callback) {
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
    public void logout() {
        Log.e("android", "logout method, nothing should call back");
    }

    @Override
    public void getList(ChannelManager.Result<ArrayList<String>> callback) {
        ArrayList<String> data = new ArrayList<>();
        data.add("user");
        data.add("name");
        data.add("is");
        data.add("big boss");
        callback.success(data);
    }

    @Override
    public void getMap(ChannelManager.Result<HashMap<String, Long>> callback) {
        HashMap<String, Long> data = new HashMap<>();
        data.put("key1", 123L);
        data.put("key2", 423L);
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

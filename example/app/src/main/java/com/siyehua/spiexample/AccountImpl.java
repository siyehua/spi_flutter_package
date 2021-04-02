package com.siyehua.spiexample;

import android.util.Log;

import com.siyehua.spiexample.channel.ChannelManager;
import com.siyehua.spiexample.channel.flutter2native.IAccount;

public class AccountImpl implements IAccount {
    @Override
    public void login(String userName, String password, ChannelManager.Result<Boolean> callback) {
        new Thread() {
            @Override
            public void run() {
                super.run();
                Log.e("android", "login method:" + userName + ", password:" + password);
                try {
                    Thread.sleep(3000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                Log.e("android", "login method: callback success: true");
                callback.success(true);
            }
        }.start();
    }

    @Override
    public void logout() {
        Log.e("android", "logout method, nothing should call back");
    }

    @Override
    public void getName(ChannelManager.Result<String> callback) {
        Log.e("android", "getName method");

        callback.success("siyehua");
    }

    @Override
    public void getAge(ChannelManager.Result<Long> callback) {
        Log.e("android", "getAge method");
        callback.success(1L);
    }
}

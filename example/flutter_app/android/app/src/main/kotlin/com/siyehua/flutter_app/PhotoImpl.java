package com.siyehua.flutter_app;

import android.util.Log;

import com.siyehua.example.chanel2.flutter2native.IPhoto;

public class PhotoImpl implements IPhoto {
    @Override
    public void aaa() {
        Log.e("android", "I'am other channel name");
    }
}

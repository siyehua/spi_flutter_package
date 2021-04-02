package com.siyehua.spiexample.channel.flutter2native;
import java.util.ArrayList;
 import java.util.HashMap;
 import com.siyehua.spiexample.channel.ChannelManager;
public interface IAccount {
 	void login(String userName, String password, ChannelManager.Result<Boolean> callback);
	void logout();
	void getName(ChannelManager.Result<String> callback);
	void getAge(ChannelManager.Result<Long> callback);
 }
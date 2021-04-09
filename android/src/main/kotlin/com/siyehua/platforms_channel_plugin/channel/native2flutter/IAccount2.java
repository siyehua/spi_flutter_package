package com.siyehua.platforms_channel_plugin.channel.native2flutter;
import java.util.ArrayList;
 import java.util.HashMap;
 import com.siyehua.platforms_channel_plugin.channel.ChannelManager;
public interface IAccount2 {
 	void login(String name, String password, ChannelManager.Result<String> callback);
	void getToken(ChannelManager.Result<String> callback);
	void logout();
	void getList(ChannelManager.Result<ArrayList<String>> callback);
	void getMap(ChannelManager.Result<HashMap<String,Long>> callback);
	void setMap(HashMap<Long, Boolean> a);
	void all(ArrayList<Long> a, HashMap<String, Long> b, Long c, ChannelManager.Result<HashMap<Long,Boolean>> callback);
 }
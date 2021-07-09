package com.siyehua.spiexample.channel.flutter2native;
import java.util.ArrayList;
 import java.util.HashMap;
 import com.siyehua.spiexample.channel.ChannelManager.Result;
public interface IAccount {
 	void login(String name, String password, Result<String> callback);
	void getToken(Result<String> callback);
	void logout();
	void getList(Result<ArrayList<String>> callback);
	void getMap(Result<HashMap<String, Long>> callback);
	void setMap(HashMap<Long, Boolean> a);
	void all(ArrayList<Long> a, HashMap<String, Long> b, Long c, Result<HashMap<Long, Boolean>> callback);
 
}
package com.siyehua.spiexample.channel.native2flutter;
import java.util.ArrayList;
 import java.util.HashMap;
 import com.siyehua.spiexample.channel.ChannelManager.Result;
public interface Fps2 {
 	void getPageName(HashMap<String, Long> t, Result<String> callback);
	void getFps(String t, Result<Double> callback);
	void add23();
 
}
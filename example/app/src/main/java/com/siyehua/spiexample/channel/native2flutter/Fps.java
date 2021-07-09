package com.siyehua.spiexample.channel.native2flutter;
import java.util.ArrayList;
 import java.util.HashMap;
 import com.siyehua.spiexample.channel.ChannelManager.Result;
public interface Fps {
 	void getPageName(Long a, Result<String> callback);
	void getFps(Result<Double> callback);
	void add11(Long b);
 
}
package com.siyehua.spiexample.channel.native2flutter;
import java.util.ArrayList;
 import java.util.HashMap;
 import com.siyehua.spiexample.channel.ChannelManager;
public interface Fps2 {
 	void getPageName(ChannelManager.Result<String> callback);
	void getFps(ChannelManager.Result<Double> callback);
	void add();
 }
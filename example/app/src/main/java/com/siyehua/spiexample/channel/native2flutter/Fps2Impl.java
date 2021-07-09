package com.siyehua.spiexample.channel.native2flutter;

import com.siyehua.spiexample.channel.ChannelManager;
import com.siyehua.spiexample.channel.ChannelManager.Result;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
public class Fps2Impl  implements Fps2{
	@Override
	public void getPageName(HashMap<String, Long> t, Result<String> callback) {
		List args = new ArrayList();
		args.add(t);
		ChannelManager.invoke(this.getClass().getInterfaces()[0], "getPageName", args, callback);
	}
	@Override
	public void getFps(String t, Result<Double> callback) {
		List args = new ArrayList();
		args.add(t);
		ChannelManager.invoke(this.getClass().getInterfaces()[0], "getFps", args, callback);
	}
	@Override
	public void add23() {
		List args = new ArrayList();
		ChannelManager.invoke(this.getClass().getInterfaces()[0], "add23", args, null);
	}
}

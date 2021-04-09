package com.siyehua.spiexample.channel.native2flutter;

import com.siyehua.spiexample.channel.ChannelManager;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
public class Fps2Impl  implements Fps2{
	@Override
	public void getPageName(ChannelManager.Result<String> callback) {
		List args = new ArrayList();
		ChannelManager.invoke(this.getClass().getInterfaces()[0], "getPageName", args, callback);
	}
	@Override
	public void getFps(ChannelManager.Result<Double> callback) {
		List args = new ArrayList();
		ChannelManager.invoke(this.getClass().getInterfaces()[0], "getFps", args, callback);
	}
	@Override
	public void add() {
		List args = new ArrayList();
		ChannelManager.invoke(this.getClass().getInterfaces()[0], "add", args, null);
	}
}

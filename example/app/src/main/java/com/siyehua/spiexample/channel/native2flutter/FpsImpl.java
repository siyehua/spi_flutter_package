package com.siyehua.spiexample.channel.native2flutter;

import com.siyehua.spiexample.channel.ChannelManager;
import com.siyehua.spiexample.channel.ChannelManager.Result;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
public class FpsImpl  implements Fps{
	@Override
	public void getPageName(Long a, Result<String> callback) {
		List args = new ArrayList();
		args.add(a);
		ChannelManager.invoke(this.getClass().getInterfaces()[0], "getPageName", args, callback);
	}
	@Override
	public void getFps(Result<Double> callback) {
		List args = new ArrayList();
		ChannelManager.invoke(this.getClass().getInterfaces()[0], "getFps", args, callback);
	}
	@Override
	public void add11(Long b) {
		List args = new ArrayList();
		args.add(b);
		ChannelManager.invoke(this.getClass().getInterfaces()[0], "add11", args, null);
	}
}

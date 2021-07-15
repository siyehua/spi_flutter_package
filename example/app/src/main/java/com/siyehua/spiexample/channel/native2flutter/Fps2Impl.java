package com.siyehua.spiexample.channel.native2flutter;

import com.siyehua.spiexample.channel.ChannelManager;
import com.siyehua.spiexample.channel.ChannelManager.Result;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;
public class Fps2Impl  implements Fps2{
	@Override
	public void getPageName( @NotNull HashMap<String, Long> t,  @NotNull String t2,  @NotNull Result<String> callback) {
		List args = new ArrayList();
		args.add(t);
		args.add(t2);
		ChannelManager.invoke(this.getClass().getInterfaces()[0], "getPageName", args, callback);
	}
	@Override
	public void getFps( @NotNull String t,  @NotNull Long a,  @NotNull Result<Double> callback) {
		List args = new ArrayList();
		args.add(t);
		args.add(a);
		ChannelManager.invoke(this.getClass().getInterfaces()[0], "getFps", args, callback);
	}
	@Override
	public void add23() {
		List args = new ArrayList();
		ChannelManager.invoke(this.getClass().getInterfaces()[0], "add23", args, null);
	}
}

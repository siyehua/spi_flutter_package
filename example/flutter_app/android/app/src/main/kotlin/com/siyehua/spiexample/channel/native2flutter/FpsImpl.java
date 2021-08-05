package com.siyehua.spiexample.channel.native2flutter;

import com.siyehua.spiexample.channel.ChannelManager;
import com.siyehua.spiexample.channel.ChannelManager.Result;
import com.siyehua.spiexample.channel.flutter2native.*;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;
public class FpsImpl  implements Fps{
	@Override
	public void getPageName( @NotNull Long a,  @NotNull Result<String> callback) {
		List args = new ArrayList();
		args.add(a);
		ChannelManager.invoke(this.getClass().getInterfaces()[0], "getPageName", args, callback);
	}
	@Override
	public void getFps( @NotNull Result<Double> callback) {
		List args = new ArrayList();
		ChannelManager.invoke(this.getClass().getInterfaces()[0], "getFps", args, callback);
	}
	@Override
	public void add11( @NotNull Long b) {
		List args = new ArrayList();
		args.add(b);
		ChannelManager.invoke(this.getClass().getInterfaces()[0], "add11", args, null);
	}
	@Override
	public void getPage( @NotNull Result<PageInfo> callback) {
		List args = new ArrayList();
		ChannelManager.invoke(this.getClass().getInterfaces()[0], "getPage", args, callback);
	}
	@Override
	public void getListCustom( @NotNull ArrayList<Long> a,  @NotNull Result<ArrayList<PageInfo>> callback) {
		List args = new ArrayList();
		args.add(a);
		ChannelManager.invoke(this.getClass().getInterfaces()[0], "getListCustom", args, callback);
	}
	@Override
	public void getMapCustom( @NotNull Result<HashMap<PageInfo, Long>> callback) {
		List args = new ArrayList();
		ChannelManager.invoke(this.getClass().getInterfaces()[0], "getMapCustom", args, callback);
	}
}

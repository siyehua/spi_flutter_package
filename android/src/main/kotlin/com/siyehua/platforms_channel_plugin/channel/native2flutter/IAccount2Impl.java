package com.siyehua.platforms_channel_plugin.channel.native2flutter;

import com.siyehua.platforms_channel_plugin.channel.ChannelManager;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
public class IAccount2Impl  implements IAccount2{
	@Override
	public void login(String name, String password, ChannelManager.Result<String> callback) {
		List args = new ArrayList();
		args.add(name);
		args.add(password);
		ChannelManager.invoke(this.getClass().getInterfaces()[0], "login", args, callback);
	}
	@Override
	public void getToken(ChannelManager.Result<String> callback) {
		List args = new ArrayList();
		ChannelManager.invoke(this.getClass().getInterfaces()[0], "getToken", args, callback);
	}
	@Override
	public void logout() {
		List args = new ArrayList();
		ChannelManager.invoke(this.getClass().getInterfaces()[0], "logout", args, null);
	}
	@Override
	public void getList(ChannelManager.Result<ArrayArrayList<String>> callback) {
		List args = new ArrayList();
		ChannelManager.invoke(this.getClass().getInterfaces()[0], "getList", args, callback);
	}
	@Override
	public void getMap(ChannelManager.Result<HashHashMap<String,Long>> callback) {
		List args = new ArrayList();
		ChannelManager.invoke(this.getClass().getInterfaces()[0], "getMap", args, callback);
	}
	@Override
	public void setMap(HashMap<Long, Boolean> a) {
		List args = new ArrayList();
		args.add(a);
		ChannelManager.invoke(this.getClass().getInterfaces()[0], "setMap", args, null);
	}
	@Override
	public void all(ArrayList<Long> a, HashMap<String, Long> b, Long c, ChannelManager.Result<HashHashMap<Long,Boolean>> callback) {
		List args = new ArrayList();
		args.add(a);
		args.add(b);
		args.add(c);
		ChannelManager.invoke(this.getClass().getInterfaces()[0], "all", args, callback);
	}
}

package com.siyehua.platforms_channel_plugin.channel.native2flutter;
import java.util.ArrayList;
 import java.util.HashMap;
 import com.siyehua.platforms_channel_plugin.channel.ChannelManager;
 import com.siyehua.platforms_channel_plugin.channel.native2flutter.InnerClass;
public class MyClass {
	public Long a ;
	public Long b =  0L;
	public Float c ;
	public String d =  "default";
	public ArrayList<Long> g ;
	public ArrayList<Long> g1 ;
	public ArrayList<Long> g2 = new ArrayList<>();
	{
		g2.add(1L);
		g2.add(2L);
		g2.add(3L);
		g2.add(4L);
	};
	public ArrayList<InnerClass> j ;
	public ArrayList<InnerClass> j1 ;
	public ArrayList<InnerClass> j2 = new ArrayList<>();
	{
		j2.add(new InnerClass());
		j2.add(new InnerClass());
	};
	public HashMap<String, Long> i ;
	public HashMap<String, Long> i1 ;
	public HashMap<String, Long> i2 = new HashMap<>();
	{
		i2.put("key", 1L);
		i2.put("key2", 2L);
	};
	public HashMap<InnerClass, Long> i3 ;
	public HashMap<InnerClass, InnerClass> i4 ;
	public HashMap<InnerClass, InnerClass> i5 = new HashMap<>();
	{
		i5.put(new InnerClass(), new InnerClass());
	};
  }
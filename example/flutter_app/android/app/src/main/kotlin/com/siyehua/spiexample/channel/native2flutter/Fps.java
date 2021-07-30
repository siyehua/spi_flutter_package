package com.siyehua.spiexample.channel.native2flutter;
import java.util.ArrayList;
 import java.util.HashMap;
 import org.jetbrains.annotations.NotNull;
 import org.jetbrains.annotations.Nullable;
 import  com.siyehua.spiexample.channel.flutter2native.*;
 import com.siyehua.spiexample.channel.ChannelManager.Result;
public interface Fps {
 	void getPageName( @NotNull Long a,  @NotNull Result<String> callback);
	void getFps( @NotNull Result<Double> callback);
	void add11( @NotNull Long b);
	void getPage( @NotNull Result<PageInfo> callback);
	void getListCustom( @NotNull ArrayList<InnerClass> a,  @NotNull Result<ArrayList<PageInfo>> callback);
	void getMapCustom( @NotNull Result<HashMap<PageInfo, Long>> callback);
 
}
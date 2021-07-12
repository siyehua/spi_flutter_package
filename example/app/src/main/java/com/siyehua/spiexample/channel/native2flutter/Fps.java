package com.siyehua.spiexample.channel.native2flutter;
import java.util.ArrayList;
 import java.util.HashMap;
 import org.jetbrains.annotations.NotNull;
 import org.jetbrains.annotations.Nullable;
 import com.siyehua.spiexample.channel.ChannelManager.Result;
public interface Fps {
 	void getPageName( @NotNull Long a,  @NotNull Result<String> callback);
	void getFps( @NotNull Result<Double> callback);
	void add11( @NotNull Long b);
 
}
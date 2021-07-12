package com.siyehua.spiexample.channel.native2flutter;
import java.util.ArrayList;
 import java.util.HashMap;
 import org.jetbrains.annotations.NotNull;
 import org.jetbrains.annotations.Nullable;
 import com.siyehua.spiexample.channel.ChannelManager.Result;
public interface Fps2 {
 	void getPageName( @NotNull HashMap<String, Long> t,  @NotNull Result<String> callback);
	void getFps( @NotNull String t,  @NotNull Result<Double> callback);
	void add23();
 
}
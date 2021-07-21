package com.siyehua.spiexample.channel.flutter2native;
import java.util.ArrayList;
 import java.util.HashMap;
 import org.jetbrains.annotations.NotNull;
 import org.jetbrains.annotations.Nullable;
 import com.siyehua.spiexample.channel.ChannelManager.Result;
public interface IAccount {
 	void login( @Nullable String name,  @NotNull String password,  @NotNull Result<String> callback);
	void getToken( @NotNull Result<String> callback);
	void logout( @NotNull InnerClass abc,  @NotNull ArrayList<InnerClass> list,  @NotNull ArrayList<ArrayList<HashMap<Long, String>>> aaa);
	void getAge( @NotNull Result<Long> callback);
	void getList( @NotNull Result<ArrayList<String>> callback);
	void getMap( @NotNull Result<HashMap<ArrayList<String>, InnerClass>> callback);
	void setMap( @Nullable HashMap<Long, Boolean> a);
	void all( @Nullable ArrayList<Long> a,  @NotNull HashMap<String, Long> b,  @Nullable Long c,  @NotNull Result<HashMap<Long, Boolean>> callback);
 
}
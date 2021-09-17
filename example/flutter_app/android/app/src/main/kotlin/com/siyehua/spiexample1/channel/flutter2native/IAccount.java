package com.siyehua.spiexample1.channel.flutter2native;
import java.util.ArrayList;
 import java.util.HashMap;
 import org.jetbrains.annotations.NotNull;
 import org.jetbrains.annotations.Nullable;
 import com.siyehua.spiexample1.channel.ChannelManager.Result;
public class IAccount {
 	void login( @Nullable String name,  @NotNull Object password,  @NotNull Result<String> callback);
	void getToken( @NotNull Result<String> callback);
	void logout( @NotNull InnerClass abc,  @NotNull ArrayList<InnerClass> list,  @NotNull ArrayList<ArrayList<HashMap<Long, String>>> aaa);
	void getAge( @NotNull Result<Long> callback);
	void getAge2( @NotNull Result<InnerClass> callback);
	void getList( @Nullable InnerClass abc,  @NotNull Result<ArrayList<String>> callback);
	void getMap( @NotNull Result<HashMap<ArrayList<String>, InnerClass>> callback);
	void setMap( @Nullable HashMap<Long, Boolean> a);
	void all( @Nullable ArrayList<Long> a,  @NotNull HashMap<String, Long> b,  @Nullable Long c,  @NotNull Result<HashMap<Long, Boolean>> callback);
 
}
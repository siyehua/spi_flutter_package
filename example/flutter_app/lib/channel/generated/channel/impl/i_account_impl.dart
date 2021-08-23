import '../channel_manager.dart';
import '../../../flutter2native/account.dart';
import 'dart:convert';
import 'dart:typed_data';
class IAccountImpl  implements IAccount, PackageTag{
	@override
	Future<String?> login(String? name, Object password, ) async{
		Type _clsType = IAccount;
		return await  ChannelManager.invoke('com.siyehua.spiexample.channel', package, _clsType.toString(), "login", "name,password,callback", [name, password]);
	}
	@override
	Future<String?> getToken() async{
		Type _clsType = IAccount;
		return await  ChannelManager.invoke('com.siyehua.spiexample.channel', package, _clsType.toString(), "getToken", "callback", );
	}
	@override
	void logout(InnerClass abc, List<InnerClass> list, List<List<Map<int, String>>> aaa, ) async{
		Type _clsType = IAccount;
		 ChannelManager.invoke('com.siyehua.spiexample.channel', package, _clsType.toString(), "logout", "abc,list,aaa", ["InnerClass___custom___" + jsonEncode(abc.toJson()), list.map((e) => "InnerClass___custom___" + jsonEncode(e.toJson())).toList(), aaa.map((e) => e.map((e) => e.map((k,v) => MapEntry(k, v))).toList()).toList()]);
	}
	@override
	Future<int> getAge() async{
		Type _clsType = IAccount;
		return await  ChannelManager.invoke('com.siyehua.spiexample.channel', package, _clsType.toString(), "getAge", "callback", );
	}
	@override
	Future<InnerClass?> getAge2() async{
		Type _clsType = IAccount;
		dynamic result = await  ChannelManager.invoke('com.siyehua.spiexample.channel', package, _clsType.toString(), "getAge2", "callback", );
		InnerClass? _b = result != null ? InnerClass.fromJson(jsonDecode(result.split("___custom___")[1])): null;
		return _b;
	}
	@override
	Future<List<String>?> getList(InnerClass? abc, ) async{
		Type _clsType = IAccount;
		dynamic result = await  ChannelManager.invoke('com.siyehua.spiexample.channel', package, _clsType.toString(), "getList", "abc,callback", ["InnerClass___custom___" + jsonEncode(abc?.toJson())]);
		List<String>? _b = (result as List?)?.map((result) =>  result as String ).toList();
		return _b;
	}
	@override
	Future<Map<List<String>?, InnerClass?>> getMap() async{
		Type _clsType = IAccount;
		dynamic result = await  ChannelManager.invoke('com.siyehua.spiexample.channel', package, _clsType.toString(), "getMap", "callback", );
		Map<List<String>?, InnerClass?> _b =  (result as Map).map((key, value) =>  MapEntry((key as List?)?.map((result) =>  result as String ).toList(),value != null ? InnerClass.fromJson(jsonDecode(value.split("___custom___")[1])): null));
		return _b;
	}
	@override
	void setMap(Map<int, bool>? a, ) async{
		Type _clsType = IAccount;
		 ChannelManager.invoke('com.siyehua.spiexample.channel', package, _clsType.toString(), "setMap", "a", [a?.map((k,v) => MapEntry(k, v))]);
	}
	@override
	Future<Map<int, bool>> all(List<int>? a, Map<String?, int> b, int? c, ) async{
		Type _clsType = IAccount;
		dynamic result = await  ChannelManager.invoke('com.siyehua.spiexample.channel', package, _clsType.toString(), "all", "a,b,c,callback", [a?.map((e) => e).toList(), b.map((k,v) => MapEntry(k, v)), c]);
		Map<int, bool> _b =  (result as Map).map((key, value) =>  MapEntry( key as int , value as bool ));
		return _b;
	}
	@override
	String package = "com.siyehua.spiexample1.channel.flutter2native";
}

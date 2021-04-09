import '../ChannelManager.dart';
import '../../../flutter2native/example.dart';
class IAccountImpl  implements IAccount, PackageTag{
	@override
	Future<String> login(String name, String password, ) {
		Type _clsType = IAccount;
		return  ChannelManager.invoke(package, _clsType.toString(), "login", [name, password]);
	}
	@override
	Future<String> getToken() {
		Type _clsType = IAccount;
		return  ChannelManager.invoke(package, _clsType.toString(), "getToken", );
	}
	@override
	void logout() {
		Type _clsType = IAccount;
		 ChannelManager.invoke(package, _clsType.toString(), "logout", );
	}
	@override
	Future<List<String>> getList() async {
		Type _clsType = IAccount;
		List<Object> _a = await  ChannelManager.invoke(package, _clsType.toString(), "getList", );
		List<String> _b = _a.map((e) => e as String).toList();
		return _b;
	}
	@override
	Future<Map<String,int>> getMap() async {
		Type _clsType = IAccount;
		Map<dynamic, dynamic> _a = await  ChannelManager.invoke(package, _clsType.toString(), "getMap", );
		Map<String, int> _b = _a.map((key, value) => MapEntry(key as String, value as int));
		return _b;
	}
	@override
	void setMap(Map<int, bool> a, ) {
		Type _clsType = IAccount;
		 ChannelManager.invoke(package, _clsType.toString(), "setMap", [a]);
	}
	@override
	Future<Map<int,bool>> all(List<int> a, Map<String, int> b, int c, ) async {
		Type _clsType = IAccount;
		Map<dynamic, dynamic> _a = await  ChannelManager.invoke(package, _clsType.toString(), "all", [a, b, c]);
		Map<int, bool> _b = _a.map((key, value) => MapEntry(key as int, value as bool));
		return _b;
	}
	@override
	String package = "com.siyehua.platforms_channel_plugin.channel.flutter2native";
}

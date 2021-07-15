import '../channel_manager.dart';
import '../../../flutter2native/account.dart';
class IAccountImpl  implements IAccount, PackageTag{
	@override
	Future<String?> login(String? name, String password, ) {
		Type _clsType = IAccount;
		return  ChannelManager.invoke(package, _clsType.toString(), "login", [name, password]);
	}
	@override
	Future<String?> getToken() {
		Type _clsType = IAccount;
		return  ChannelManager.invoke(package, _clsType.toString(), "getToken", );
	}
	@override
	void logout() {
		Type _clsType = IAccount;
		 ChannelManager.invoke(package, _clsType.toString(), "logout", );
	}
	@override
	Future<List<String>?> getList() async {
		Type _clsType = IAccount;
		dynamic result = await  ChannelManager.invoke(package, _clsType.toString(), "getList", );
		List<String>? _b = (result as List?)?.map((result) =>  result as String ).toList();
		return _b;
	}
	@override
	Future<Map<List<String>?, int>> getMap() async {
		Type _clsType = IAccount;
		dynamic result = await  ChannelManager.invoke(package, _clsType.toString(), "getMap", );
		Map<List<String>?, int> _b =  (result as Map).map((key, value) =>  MapEntry((key as List?)?.map((result) =>  result as String ).toList(), value as int ));
		return _b;
	}
	@override
	void setMap(Map<int, bool>? a, ) {
		Type _clsType = IAccount;
		 ChannelManager.invoke(package, _clsType.toString(), "setMap", [a]);
	}
	@override
	Future<Map<int, bool>> all(List<int>? a, Map<String?, int> b, int? c, ) async {
		Type _clsType = IAccount;
		dynamic result = await  ChannelManager.invoke(package, _clsType.toString(), "all", [a, b, c]);
		Map<int, bool> _b =  (result as Map).map((key, value) =>  MapEntry( key as int , value as bool ));
		return _b;
	}
	@override
	String package = "com.siyehua.spiexample.channel.flutter2native";
}

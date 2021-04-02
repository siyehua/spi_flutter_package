import '../ChannelManager.dart';
import '../../../flutter2native/account.dart';
class IAccountImpl  implements IAccount, PackageTag{
	@override
	Future<bool> login(String userName, String password, ) {
		Type _clsType = IAccount;
		return  ChannelManager.invoke(package, _clsType.toString(), "login", [userName, password]);
	}
	@override
	void logout() {
		Type _clsType = IAccount;
		 ChannelManager.invoke(package, _clsType.toString(), "logout", );
	}
	@override
	Future<String> getName() {
		Type _clsType = IAccount;
		return  ChannelManager.invoke(package, _clsType.toString(), "getName", );
	}
	@override
	Future<int> getAge() {
		Type _clsType = IAccount;
		return  ChannelManager.invoke(package, _clsType.toString(), "getAge", );
	}
	@override
	String package = "com.siyehua.spiexample.channel.flutter2native";
}

import '../channel_manager.dart';
import '../../../flutter2native/account.dart';
import 'dart:convert';
import 'dart:typed_data';
class TestPreClassNameImpl  implements TestPreClassName, PackageTag{
	@override
	void aaa() async{
		Type _clsType = TestPreClassName;
		 ChannelManager.invoke('com.siyehua.spiexample.channel', package, _clsType.toString(), "aaa", "", );
	}
	@override
	String package = "com.siyehua.spiexample.channel.flutter2native";
}

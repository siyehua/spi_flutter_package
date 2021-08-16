import '../channel_manager.dart';
import '../../../flutter2native/account.dart';
import 'dart:convert';
import 'dart:typed_data';
class TestPreClassName2Impl  implements TestPreClassName2, PackageTag{
	@override
	void aaa() async{
		Type _clsType = TestPreClassName2;
		 ChannelManager.invoke('com.siyehua.spiexample.channel', package, _clsType.toString(), "aaa", "", );
	}
	@override
	String package = "com.siyehua.spiexample.channel.flutter2native";
}

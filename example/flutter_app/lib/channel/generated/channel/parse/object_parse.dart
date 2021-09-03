import 'dart:typed_data';
import 'dart:convert';
extension  IParse on Object{
	dynamic parse(instance, String cls, String method, [dynamic args]) {
		if("IPhoto2.aaa" == "$cls.$method") {
			return instance.aaa();
		}
		if("Fps.getPageName" == "$cls.$method") {
		args[0] =   args[0] as int ;
			return instance.getPageName(args[0], ).then((value) => value);
		}
		if("Fps.getFps" == "$cls.$method") {
			return instance.getFps().then((value) => value);
		}
		if("Fps.add11" == "$cls.$method") {
		args[0] =   args[0] as int ;
			return instance.add11(args[0], );
		}
		if("Fps.getPage" == "$cls.$method") {
			return instance.getPage().then((value) => "PageInfo___custom___" + jsonEncode(value.toJson()));
		}
		if("Fps.getListCustom" == "$cls.$method") {
		args[0] =  (args[0] as List).map((result) =>  result as int ).toList();
			return instance.getListCustom(args[0], ).then((value) => value.map((e) => "PageInfo___custom___" + jsonEncode(e.toJson())).toList());
		}
		if("Fps.getMapCustom" == "$cls.$method") {
			return instance.getMapCustom().then((value) => value.map((k,v) => MapEntry("PageInfo___custom___" + jsonEncode(k.toJson()), v)));
		}
		if("Fps2.getPageName" == "$cls.$method") {
		args[0] =   (args[0] as Map).map((key, value) =>  MapEntry( key as String , value as int ));
		args[1] =   args[1] as String ;
			return instance.getPageName(args[0], args[1], ).then((value) => value);
		}
		if("Fps2.getFps" == "$cls.$method") {
		args[0] =   args[0] as String ;
		args[1] =   args[1] as int ;
			return instance.getFps(args[0], args[1], ).then((value) => value);
		}
		if("Fps2.add23" == "$cls.$method") {
			return instance.add23();
		}
	}
}

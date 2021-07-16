import 'dart:typed_data';
extension  IParse on Object{
	dynamic parse(instance, String cls, String method, [dynamic args]) {
		if("Fps.getPageName" == "$cls.$method") {
		args[0] =   args[0] as int ;
			return instance.getPageName(args[0], );
		}
		if("Fps.getFps" == "$cls.$method") {
			return instance.getFps();
		}
		if("Fps.add11" == "$cls.$method") {
		args[0] =   args[0] as int ;
			return instance.add11(args[0], );
		}
		if("Fps2.getPageName" == "$cls.$method") {
		args[0] =   (args[0] as Map).map((key, value) =>  MapEntry( key as String , value as int ));
		args[1] =   args[1] as String ;
			return instance.getPageName(args[0], args[1], );
		}
		if("Fps2.getFps" == "$cls.$method") {
		args[0] =   args[0] as String ;
		args[1] =   args[1] as int ;
			return instance.getFps(args[0], args[1], );
		}
		if("Fps2.add23" == "$cls.$method") {
			return instance.add23();
		}
	}
}

extension  IParse on Object{
	dynamic parse(instance, String cls, String method, [dynamic args]) {
		if("Fps.getPageName" == "$cls.$method") {
			return instance.getPageName(args[0], );
		}
		if("Fps.getFps" == "$cls.$method") {
			return instance.getFps();
		}
		if("Fps.add11" == "$cls.$method") {
			return instance.add11(args[0], );
		}
		if("Fps2.getPageName" == "$cls.$method") {
			return instance.getPageName(args[0], );
		}
		if("Fps2.getFps" == "$cls.$method") {
			return instance.getFps(args[0], );
		}
		if("Fps2.add23" == "$cls.$method") {
			return instance.add23();
		}
	}
}

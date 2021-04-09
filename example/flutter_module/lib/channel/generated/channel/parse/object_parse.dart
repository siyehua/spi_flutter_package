extension  IParse on Object{
	dynamic parse(instance, String cls, String method, [dynamic args]) {
		if ("$cls.getPageName" == "$cls.$method") {
			return instance.getPageName() ;
		}
		if ("$cls.getFps" == "$cls.$method") {
			return instance.getFps() ;
		}
		if ("$cls.add" == "$cls.$method") {
			return instance.add() ;
		}
		if ("$cls.getPageName" == "$cls.$method") {
			return instance.getPageName() ;
		}
		if ("$cls.getFps" == "$cls.$method") {
			return instance.getFps() ;
		}
		if ("$cls.add" == "$cls.$method") {
			return instance.add() ;
		}
	}
}

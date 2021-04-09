extension  IParse on Object{
	T parse<T>(instance, String cls, String method, [dynamic args]) {
		if ("$cls.getPageName" == "$cls.$method") {
			return instance.getPageName() as T;
		}
		if ("$cls.getFps" == "$cls.$method") {
			return instance.getFps() as T;
		}
		if ("$cls.add" == "$cls.$method") {
			return instance.add() as T;
		}
		if ("$cls.getPageName" == "$cls.$method") {
			return instance.getPageName() as T;
		}
		if ("$cls.getFps" == "$cls.$method") {
			return instance.getFps() as T;
		}
		if ("$cls.add" == "$cls.$method") {
			return instance.add() as T;
		}
	}
}

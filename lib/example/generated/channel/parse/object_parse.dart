extension  IParse on Object{
	dynamic parse(instance, String cls, String method, [dynamic args]) {
		if ("$cls.login" == "$cls.$method") {
			return instance.login(args[0], args[1], );
		}
		if ("$cls.getToken" == "$cls.$method") {
			return instance.getToken();
		}
		if ("$cls.logout" == "$cls.$method") {
			return instance.logout();
		}
		if ("$cls.getList" == "$cls.$method") {
			return instance.getList();
		}
		if ("$cls.getMap" == "$cls.$method") {
			return instance.getMap();
		}
		if ("$cls.setMap" == "$cls.$method") {
			return instance.setMap(args[0], );
		}
		if ("$cls.all" == "$cls.$method") {
			return instance.all(args[0], args[1], args[2], );
		}
	}
}

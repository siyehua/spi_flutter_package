abstract class IAccount {
  Future<String?> login(String? name, String password);

  Future<String?> getToken();

  void logout();

  Future<List<String>?> getList();

  Future<Map<String?, int>> getMap();

  void setMap(Map<int, bool>? a);

  Future<Map<int, bool>> all(List<int>? a, Map<String?, int> b, int? c);
}

class MyClass {
  int? a;
  int b = 0;
  double? c;
  String? d = "default";

  // Object h; //it's not support.
  List<int>? g;
  List<int> g1 = [];
  List<int> g2 = [1, 2, 3, 4];
  List<InnerClass>? j;
  List<InnerClass> j1 = [];
  List<InnerClass>? j2 = [InnerClass(), InnerClass()];

  // List e = []; //don't do it, is the same List<dynamic>, it's not support
  // List<dynamic> f = []; ////don't do it, dynamic is not support

  Map<String, int>? i;
  Map<String, int> i1 = {};
  Map<String?, int> i2 = {"key": 1, "key2": 2};
  Map<InnerClass, int>? i3;
  Map<InnerClass, InnerClass?>? i4;
  Map<InnerClass?, InnerClass>? i5 = {InnerClass(): InnerClass()};
}

class InnerClass {
  String? a;
  int? b;
}

class Route {
  static const String main_page = "/main/page";
  static const String mine_main = "/mine/main";
  static const int int_value = 123;
}

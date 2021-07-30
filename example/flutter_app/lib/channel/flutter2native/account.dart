import 'dart:convert';

abstract class IAccount {
  Future<String?> login(String? name, Object password);

  Future<String?> getToken();

  void logout(InnerClass abc, List<InnerClass> list, List<List<Map<int, String>>> aaa);

  Future<int> getAge();

  Future<InnerClass> getAge2();

  Future<List<String>?> getList(InnerClass? abc);

  Future<Map<List<String>?, InnerClass>> getMap();

  void setMap(Map<int, bool>? a);

  Future<Map<int, bool>> all(List<int>? a, Map<String?, int> b, int? c);
}

abstract class TestPreClassName {
  void aaa();
}

class MyClass {
  /// Note: this method create by SPI, if change Class property or method,
  /// please remove it. it will be carted by SPI again.
  MyClass();

  /// Note: this method create by SPI, if change Class property or method,
  /// please remove it. it will be carted by SPI again.
  MyClass.fromJson(Map<String, dynamic> json) {
    abc = InnerClass.fromJson(json['abc']);
    if (json['aaa'] != null) {
      aaa = [];
      json['aaa'].forEach((v) {
        aaa!.add((v as Map).map((key, value) => MapEntry((key as Map).map((key, value) => MapEntry((key as List?)?.map((result) => result as String?).toList(), value as int)), (value as List?)?.map((result) => result as int).toList())));
      });
    }
    a = json['a'];
    b = json['b'];
    c = json['c'];
    d = json['d'];
    if (json['g'] != null) {
      g = [];
      json['g'].forEach((v) {
        g!.add(v as int);
      });
    }
    if (json['g1'] != null) {
      g1 = [];
      json['g1'].forEach((v) {
        g1.add(v as int);
      });
    }
    if (json['g2'] != null) {
      g2 = [];
      json['g2'].forEach((v) {
        g2.add(v as int);
      });
    }
    if (json['j'] != null) {
      j = [];
      json['j'].forEach((v) {
        j!.add(InnerClass.fromJson(jsonDecode(v.split("___custom___")[1])));
      });
    }
    if (json['j1'] != null) {
      j1 = [];
      json['j1'].forEach((v) {
        j1.add(InnerClass.fromJson(jsonDecode(v.split("___custom___")[1])));
      });
    }
    if (json['j2'] != null) {
      j2 = [];
      json['j2'].forEach((v) {
        j2!.add(InnerClass.fromJson(jsonDecode(v.split("___custom___")[1])));
      });
    }
    if (json['i'] != null) {
      i = {};
      json['i'].forEach((k, v) {
        i!.update(k as String, (value) => v as int, ifAbsent: () => v as int);
      });
    }
    if (json['i1'] != null) {
      i1 = {};
      json['i1'].forEach((k, v) {
        i1.update(k as String, (value) => v as int, ifAbsent: () => v as int);
      });
    }
    if (json['i2'] != null) {
      i2 = {};
      json['i2'].forEach((k, v) {
        i2.update(k as String?, (value) => v as int, ifAbsent: () => v as int);
      });
    }
    if (json['i3'] != null) {
      i3 = {};
      json['i3'].forEach((k, v) {
        i3!.update(InnerClass.fromJson(jsonDecode(k.split("___custom___")[1])), (value) => v as int, ifAbsent: () => v as int);
      });
    }
    if (json['i4'] != null) {
      i4 = {};
      json['i4'].forEach((k, v) {
        i4!.update(InnerClass.fromJson(jsonDecode(k.split("___custom___")[1])), (value) => InnerClass.fromJson(jsonDecode(v.split("___custom___")[1])), ifAbsent: () => InnerClass.fromJson(jsonDecode(v.split("___custom___")[1])));
      });
    }
    if (json['i5'] != null) {
      i5 = {};
      json['i5'].forEach((k, v) {
        i5!.update(InnerClass.fromJson(jsonDecode(k.split("___custom___")[1])), (value) => InnerClass.fromJson(jsonDecode(v.split("___custom___")[1])), ifAbsent: () => InnerClass.fromJson(jsonDecode(v.split("___custom___")[1])));
      });
    }
  }

  /// Note: this method create by SPI, if change Class property or method,
  /// please remove it. it will be carted by SPI again.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['abc'] = abc?.toJson();
    data['aaa'] = this.aaa?.map((v) => v.map((k, v) => MapEntry(k.map((k, v) => MapEntry(k?.map((v) => v).toList(), v)), v?.map((v) => v).toList()))).toList();
    data['a'] = this.a;
    data['b'] = this.b;
    data['c'] = this.c;
    data['d'] = this.d;
    data['g'] = this.g?.map((v) => v).toList();
    data['g1'] = this.g1.map((v) => v).toList();
    data['g2'] = this.g2.map((v) => v).toList();
    data['j'] = this.j?.map((v) => v.toJson()).toList();
    data['j1'] = this.j1.map((v) => v.toJson()).toList();
    data['j2'] = this.j2?.map((v) => v.toJson()).toList();
    data['i'] = this.i?.map((k, v) => MapEntry(k, v));
    data['i1'] = this.i1.map((k, v) => MapEntry(k, v));
    data['i2'] = this.i2.map((k, v) => MapEntry(k, v));
    data['i3'] = this.i3?.map((k, v) => MapEntry(k.toJson(), v));
    data['i4'] = this.i4?.map((k, v) => MapEntry(k.toJson(), v?.toJson()));
    data['i5'] = this.i5?.map((k, v) => MapEntry(k?.toJson(), v.toJson()));
    return data;
  }

  InnerClass? abc;
  List<Map<Map<List<String?>?, int>, List<int>?>>? aaa;

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
  /// Note: this method create by SPI, if change Class property or method,
  /// please remove it. it will be carted by SPI again.
  InnerClass();

  /// Note: this method create by SPI, if change Class property or method,
  /// please remove it. it will be carted by SPI again.
  InnerClass.fromJson(Map<String, dynamic> json) {
    a = json['a'];
    b = json['b'];
  }

  /// Note: this method create by SPI, if change Class property or method,
  /// please remove it. it will be carted by SPI again.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['a'] = this.a;
    data['b'] = this.b;
    return data;
  }

  String? a;
  int? b;
}

class Route {
  static const String main_page = "/main/page";
  static const String mine_main = "/mine/main";
  static const int int_value = 123;
}

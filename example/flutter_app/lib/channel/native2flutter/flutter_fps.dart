abstract class Fps {
  Future<String> getPageName(int a);

  Future<double> getFps();

  void add11(int b);

  Future<PageInfo> getPage();

  Future<List<PageInfo>> getListCustom(List<int> a);

  Future<Map<PageInfo, int>> getMapCustom();
}

class PageInfo {
  PageInfo();
  PageInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    fps = json['fps'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['fps'] = this.fps;
    return data;
  }

  String name = "";
  String id = "";
  double fps = 0;
}

abstract class Fps2 {
  Future<String> getPageName(Map<String, int> t, String t2);

  Future<double> getFps(String t, int a);

  void add23();
}

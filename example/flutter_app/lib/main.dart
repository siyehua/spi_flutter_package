import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/channel/native2flutter/other_busniess.dart';

import 'channel/flutter2native/account.dart';
import 'channel/flutter2native/other_busniess.dart';
import 'channel/generated/channel/channel_manager.dart';
import 'channel/native2flutter/flutter_fps.dart';

class FpsImpl extends Fps {
  @override
  Future<double> getFps() {
    print("getFps method");
    return Future.delayed(Duration(seconds: 1)).then((value) => 3.1415826);
  }

  @override
  Future<String> getPageName(int a) {
    print("getPageName method:$a");
    return Future.delayed(Duration(seconds: 3)).then((value) => "main page");
  }

  @override
  void add11(int b) {
    print("add method:$b");
  }

  int point = 0;

  FpsImpl() {
    point = Random().nextInt(10000000);
  }

  @override
  String toString() {
    return 'FpsImpl{point: $point}';
  }

  @override
  Future<PageInfo> getPage() {
    return Future.delayed(Duration(seconds: 3)).then((value) {
      PageInfo info = PageInfo();
      info.name = "getPage";
      info.id = "123";
      info.fps = 60;
      return info;
    });
  }

  @override
  Future<List<PageInfo>> getListCustom(List<int> a) {
    print("getListCustom: $a");
    return Future.delayed(Duration(seconds: 3)).then((value) {
      PageInfo info = PageInfo();
      info.name = "getListCustom";
      info.id = "123";
      info.fps = 60;
      return [info];
    });
  }

  @override
  Future<Map<PageInfo, int>> getMapCustom() {
    // TODO: implement getMapCustom
    throw UnimplementedError();
  }
}

class FpsImpl2 extends Fps2 {
  int point = 0;

  FpsImpl2() {
    point = Random().nextInt(10000000);
  }

  @override
  String toString() {
    return 'FpsImpl2{point: $point}';
  }

  @override
  Future<double> getFps(String t, int a) {
    print("getFps method2:$t");
    return Future.delayed(Duration(seconds: 1)).then((value) => 3.1415826);
  }

  @override
  Future<String> getPageName(Map<String, int> t, String t2) {
    print("getPageName method2");
    return Future.delayed(Duration(seconds: 3)).then((value) => "main page");
  }

  @override
  void add23() {
    print("add method2");
  }
}

class Photo2 extends IPhoto2 {
  @override
  void aaa() {
    print("aaa method invoke by native use other channel name");
  }
}

void main() {
  runApp(MyApp());
  initFlutter();
}

void initFlutter() async {
  ChannelManager.init();
  ChannelManager.add(Fps, FpsImpl());
  ChannelManager.add(Fps2, FpsImpl2());
  ChannelManager.add(IPhoto2, Photo2());

  IAccount account = ChannelManager.getChannel(IAccount);
  var result = await account.login(null, "2");
  print(result);
  var a = InnerClass();
  a.a = "1334";
  a.b = 18;
  var list2 = <InnerClass>[];
  list2.add(a);
  list2.add(a);
  list2.add(a);
  list2.add(a);
  List<List<Map<int, String>>> aaa = [];
  aaa.add([
    {1: "value", 2: "value2"}
  ]);
  account.logout(a, list2, aaa);
  var name = await account.getToken();
  print(name);
  var list = await account.getList(null);
  print(list);
  var map = await account.getMap();
  print(map);
  account.setMap({1: true});
  var allResult = await account.all([
    4,
    6,
    6,
    6,
    77,
  ], {
    "key from flutter": 10086
  }, -1100);
  print(allResult);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in a Flutter IDE). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title = ""}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

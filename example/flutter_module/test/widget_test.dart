// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'dart:isolate';

import 'package:flutter_module/channel/flutter2native/account.dart';
import 'package:spi_flutter_package/spi_flutter_package.dart';

void main() async {
  String flutterPath = "./lib/channel";//需要转换的 dart 目录
  String packageName = "com.siyehua.spiexample.channel";//java 包名
  String androidSavePath = "../app/src/main/java";//需要保存的 java 路径
  await spiFlutterPackageStart(flutterPath, packageName, androidSavePath);
}
// void main(){
//   String json = """
//       {"aaa":
//         [{
//           "key1":[1],
//           "key2":[2],
//           "key3":[3]
//         }]
//       }
//     """;
//   var cls = MyClass.fromJson(jsonDecode(json));
//   print(cls);
//
// }
# spi_flutter_package

一个自动生成跨平台通信框架的工具<br>

# 背景
该工具主要是为了解决 flutter 在跨平台通信时遇到的一些问题, 例如:
1. 找不到 channel name
2. 对应的方法未实现

以 [MethodChannel](https://flutter.dev/docs/development/platform-integration/platform-channels) 官方为例,
flutter 调用到原生平台的时候, channelName 和对应的方法名, 参数, 返回值, 都是直接硬编码的, 非常容易出错, 经常会出现找不到对应的
 channel 或方法. 而且通信的协议多了, 就很难维护, 两个平台之间谁也不知道对应的方法实现了没有.

为了尽量减少这种情况的发生, 我们采用了 SPI(Service Provider Interface) 模式, 集中管理所有的通信协议, 统一标准, 让协议的定义和实现
解耦, 解决 platform channel 使用过程中的各种问题.

# 快速集成

1. 首先请根据[安装指引](https://pub.dev/packages/spi_flutter_package/install), 将当前 package 下载到项目中,
这里推荐直接加载 `dev_dependencies` 中, 因为它仅仅是一个工具, 无需与 APP 自身的源码一起导出发布:

```
dev_dependencies:
  spi_flutter_package:
    path: version
```

下载完成之后, 在 flutter 工程中, 新建一个目录 `lib/channel`, 这里用来存储通信协议的源码:

```
|____main.dart
|____channel //通信协议源目录
| |____flutter2native //flutter 调用原生平台源码
| | |____account.dart //自己自定义的通信协议
| |____native2flutter //原生平台调用 flutter 源码
| | |____flutter_fps.dart //自己自定义的通信协议
```

在 `account.dart` (文件名可自定义)文件中, 定义 flutter 调用原生平台的通信协议:

```dart
abstract class IAccount{
  Future<bool> login(String userName,String password);
  void logout();
  Future<String> getName();
  Future<int> getAge();
}
```

更多例子请看 `example`

2. 在 flutter 工程的 test 目录下, 任意一个 dart 文件中写下:

```dart
import 'package:spi_flutter_package/spi_flutter_package.dart';
import 'package:spi_flutter_package/file_config.dart';

void main() async {
  await spiFlutterPackageStart([
    FlutterPlatformConfig()
      ..sourceCodePath = "./lib/channel" //flutter source code
      ..channelName = "com.siyehua.spiexample.channel" //channel name
    ,
    AndroidPlatformConfig()
      ..savePath = "./android/app/src/main/kotlin" //android save path
    ,
    IosPlatformConfig()
      ..iosProjectPrefix = "MQQFlutterGen_" //iOS pre
      ..savePath = "./ios/Classes" //iOS save path
    ,
  ], nullSafe: true);
}
```

点击左边的运行图标 ▶️, 运行当前的 `main()` 方法, 很快, 对应的目录下就会自动生成代码, 详情请看自动生成代码的存放路径和说明
<br>代码生成完毕后, 在对应的平台实现实现该通信协议, 以 Android 为例:

```java
public class AccountImpl implements IAccount {
    //....

    @Override
    public void logout() {
        Log.e("android", "logout method, nothing should call back");
    }

    @Override
    public void getName(ChannelManager.Result<String> callback) {
        Log.e("android", "getName method");

        callback.success("siyehua");
    }

    @Override
    public void getAge(ChannelManager.Result<Long> callback) {
        Log.e("android", "getAge method");
        callback.success(1L);
    }
}
```

3. 实现完成之后, 就可以使用通信框架进行调用了
<br>在 Android 端:

```java
//1. 初始化(仅需一次)

```java
ChannelManager.init(flutterEngine.getDartExecutor(), new ChannelManager.JsonParse() {
    @Nullable
    @Override
    public String toJSONString(@Nullable Object object) {
        //your json parse
        return JSON.toJSONString(object);
    }

    @Nullable
    @Override
    public <T> T parseObject(@Nullable String text, @NonNull Class<T> clazz) {
        //your json parse
        return JSON.parseObject(text, clazz);
    }
});
```

//2. 将上面实现的类加入到 ChannelManager 中, 以便 flutter 能够调用到
ChannelManager.addChannelImpl(IAccount.class, new AccountImpl());
```

<br>在 flutter 端:

```dart
//1. 初始化(仅需一次)
  ChannelManager.init();

//2. 调用,即可看到打印的结果
  IAccount account = ChannelManager.getChannel(IAccount);
  var result = await account.login("userName", "password");
  print(result);
  account.logout();
  var name = await account.getName();
  print(name);
  var age = await account.getAge();
  print(age);
```

更多详情请看 `example`, 运行整个项目后, 即可看到调用结果

# 自动生成代码

在 flutter 工程中, 自定生成的代码, 会自动存放在之前定义的 `flutterPath`/generated 目录下:

```
|____main.dart
|____channel
| |____generated //自动生成的代码
| | |____channel
| | | |____impl
| | | | |____iaccount_impl.dart
| | | |____parse
| | | | |____object_parse.dart
| | | |____ChannelManager.dart
| |____flutter2native //flutter 调用原生平台源码
| | |____account.dart
| |____native2flutter //原生平台调用 flutter 源码
| | |____flutter_fps.dart
```

对比可以发现, 在自定义目录下, 多了一个自动生成的 generated, 该目录就是 package 自动生成的代码.
<br>同样, 在 Android 项目中, 你之前填的 `androidSavePath` + packageName 目录下, 自定生成了对应的代码:

```
.
|____com
| |____siyehua
| | |____spiexample
| | | |____MainActivity2.java
| | | |____AccountImpl.java
| | | |____MainActivity.kt
| | | |____channel //整个目录都是自动生成的文件
| | | | |____flutter2native
| | | | | |____IAccount.java
| | | | |____native2flutter
| | | | | |____Fps2.java
| | | | | |____FpsImpl.java
| | | | | |____Fps2Impl.java
| | | | | |____Fps.java
| | | | |____ChannelManager.java

```

**注意: 自动生成的代码不建议修改, 每次工具执行的时候, 都会覆盖掉修改**

# 混淆配置
注意：如果你开启了混淆，请在 `proguard-rules.pro` 文件中添加：

```
# in example, the package name is "com.siyehua.spiexample.channel"
-keep class {your android package name}.** {*;}
```

# 注意事项
## 支持的类型和属性, 详见: [platforms_source_gen](https://pub.dev/packages/platforms_source_gen)
## 所有的 dart 通信协议都必须返回 Future 或 void
因为 Flutter 的 Channel 本身返回必须是 Future ,异步的
# spi_flutter_package

a dev tools create platform's code when use Platform channel exchange data<br>

## [中文文档](https://github.com/siyehua/spi_flutter_package/blob/master/README_CN.md)

# Getting Started

1. first, [install](https://pub.dev/packages/spi_flutter_package/install) it in your flutter project,
recommended you add this tools in `dev_dependencies`, because it's a dev tools, so you don't need publish
with your project sourcecode:

```
dev_dependencies:
  spi_flutter_package:
    path: version
```

and, in your flutter project, create custom dir: `lib/channel`, the dir use save your flutter channel dart code:

```
|____main.dart
|____channel //your flutter channel
| |____flutter2native //flutter invoke native dir
| | |____account.dart //your interface code
| |____native2flutter //native invoke flutter dir
| | |____flutter_fps.dart // your interface code
```

create `account.dart`:

```dart
abstract class IAccount{
  Future<bool> login(String userName,String password);
  void logout();
  Future<String> getName();
  Future<int> getAge();
}
```

more code: `example`

2. in flutter project `test` dir,open any dart file and write:

```dart
import 'package:spi_flutter_package/spi_flutter_package.dart';

void main() async {
  String flutterPath = "./lib/channel";//your flutter project channel dir in 1 step.
  String packageName = "com.siyehua.spiexample.channel";//your android code package name
  String androidSavePath = "../app/src/main/java";//your android project project sourcecode path
  await spiFlutterPackageStart(flutterPath, packageName, androidSavePath, nullSafe: false);
}
```

click left icon: ▶️, run `main()`, and you will find the generated code in your custom path. the more
info, you can checkout `generated code`.
<br>when code auto create finish, you can add `impl` in platforms, eg: Android:

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

3. Now, you can use this tools exchange data
<br>in Android project:

```java
//1. init(only first)

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

//2. add your impl class in  ChannelManager
ChannelManager.addChannelImpl(IAccount.class, new AccountImpl());
```

<br>in flutter project:

```dart
//1. init(only first)
  ChannelManager.init();

//2. invoke
  IAccount account = ChannelManager.getChannel(IAccount);
  var result = await account.login("userName", "password");
  print(result);
  account.logout();
  var name = await account.getName();
  print(name);
  var age = await account.getAge();
  print(age);
```

now, run your project and check result.<br>
more info, you can check `example`

# generated code

in flutter project, the code will save in `flutterPath`/generated :

```
|____main.dart
|____channel
| |____generated //auto create
| | |____channel
| | | |____impl
| | | | |____iaccount_impl.dart
| | | |____parse
| | | | |____object_parse.dart
| | | |____ChannelManager.dart
| |____flutter2native //flutter invoke native
| | |____account.dart
| |____native2flutter //native invoke flutter
| | |____flutter_fps.dart
```


<br>yet, you can find the auto create code  in Android project, in `androidSavePath` + packageName dir:

```
.
|____com
| |____siyehua
| | |____spiexample
| | | |____MainActivity2.java
| | | |____AccountImpl.java
| | | |____MainActivity.kt
| | | |____channel //auto create
| | | | |____flutter2native
| | | | | |____IAccount.java
| | | | |____native2flutter
| | | | | |____Fps2.java
| | | | | |____FpsImpl.java
| | | | | |____Fps2Impl.java
| | | | | |____Fps.java
| | | | |____ChannelManager.java

```

**Note: auto create code should not be edited**

# Other
## support: [platforms_source_gen](https://pub.dev/packages/platforms_source_gen)
## all method must return  `Future` or `void`
because Flutter Platform Channel must return `Future`
abstract class IAccount{
  Future<bool> login(String userName,String password);
  void logout();
  Future<String> getName();
  Future<int> getAge();
}
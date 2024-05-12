import 'package:shared_preferences/shared_preferences.dart';


Future<void> setSharedPref(String username, String password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('email', username);
  await prefs.setString('password', password);
}


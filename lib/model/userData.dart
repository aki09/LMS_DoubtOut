import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  Future setUserLoggedIn(
      String email, String uid, String name, String photoUrl) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('loggedIn', true);
    prefs.setString('email', email);
    prefs.setString('userId', uid);
    prefs.setString('name', name);
    prefs.setString('photoUrl', photoUrl);
  }

  Future getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return [
      prefs.getString('userId'),
      prefs.getString('name'),
      prefs.getString('email'),
      prefs.getString('photoUrl'),
      prefs.getString('id'),
    ];
  }

  Future logoutUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('loggedIn', false);
    prefs.setString('email', '');
    prefs.setString('userId', '');
    prefs.setString('name', '');
    prefs.setString('photoUrl', '');
    prefs.setString('id', '');
    prefs.setBool('loggedId', false);
    prefs.setInt('accountStatus', 0);
  }

  Future setAccountStatus(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('accountStatus', value);
  }

  Future getAccountStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('accountStatus');
  }

  Future setUserStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('id', value);
    prefs.setBool('loggedId', true);
  }

  Future getUserStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loggedId');
  }

  Future getUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loggedIn');
  }
}

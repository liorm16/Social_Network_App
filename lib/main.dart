import 'package:daesh_app/app_screens/log_in.dart';
import 'package:daesh_app/app_screens/main_screen.dart';
import 'package:daesh_app/const_data/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;





void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {
  bool isDark = true;

  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if (jwt == null) return "";
    var res = await http.post(
        serverip + "/login/token",
        headers: {
          "Authorization": jwt,
        }
    );
    if (res.statusCode == 200) return jwt;
    if (res.statusCode == 403) return "";
    return "";
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Constants.darkPrimary,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      theme: Constants.appTheme,
      home: FutureBuilder(
          future: jwtOrEmpty,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return log_in();
            }
            if (snapshot.data != "") {
              return MainScreen();
            } else {
              return log_in();
            }
          }
      ),
    );
  }

}

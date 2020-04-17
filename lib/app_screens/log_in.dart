import 'dart:async';
import 'dart:convert';
import 'dart:convert' show json, base64, ascii;

import 'package:daesh_app/app_screens/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'main_screen.dart';

const serverip = "http://10.0.2.2:5000";
final storage = FlutterSecureStorage();

class log_in extends StatefulWidget {
  log_in({Key key}) : super(key: key);

  @override
  _log_in_State createState() {
    return _log_in_State();
  }
}

class _log_in_State extends State<log_in> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  Icon submit_btn_icn = Icon(Icons.done);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        resizeToAvoidBottomInset: true,
        body: Center(child:
        SafeArea(
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: [BoxShadow(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      blurRadius: 5.0,
                      spreadRadius: 5.0,
                      // has the effect of extending the shadow
                      offset: Offset(
                        5.0, // horizontal, move right 10
                        5.0, // vertical, move down 10
                      ),
                    ),
                    ]),
        child: Card(
          elevation: 10.0,
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Welcome to Daesh!', textScaleFactor: 2.0),
                  TextFormField(
                    controller: _username,
                    decoration: InputDecoration(
                      hintText: 'username',
                      icon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _password,
                    decoration: InputDecoration(
                      hintText: 'password',
                      icon: Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  RaisedButton(
                      child: submit_btn_icn,
                      onPressed: () async {
                        var username = _username.text;
                        var password = _password.text;

                        var jwt = await attemptLogIn(
                            context, username, password);
                        if (jwt != null) {
                          storage.write(key: "jwt", value: jwt);
                          print('this is jwt from login.dart   ' + jwt);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainScreen()
                              )
                          );
                        } else {
                          displayDialog(context, "An Error Occurred",
                              "No account was found matching that username and password");
                        }
                      },
                      color: Theme.of(context).backgroundColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(1.0))),
                  Text(''),
                ],
              )),
        ),
      ),
            ))));
  }
}

Future<String> attemptLogIn(BuildContext context, String username,
    String password) async {
  Map data = {
    "username": username,
    "password": password
  };
  var body = json.encode(data);
  var res = await http.post(
      serverip + "/login",
      headers: {"Content-Type": "application/json"},
      body: body
  );
  if (res.statusCode == 200)
    return json.decode(res.body)["token"];
  else if (res.statusCode == 401) {
    //displayDialog(context,res.body, "error");
    return null;
  }
  return null;
}

logInFromJson(Map data) {
  return data['Authorization'];
}

void displayDialog(BuildContext context, String title, String text) =>
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
              title: Text(title),
              content: Text(text)
          ),
    );

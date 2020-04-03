import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:daesh_app/user.dart';
import 'dart:async';
import 'dart:convert';
import 'package:daesh_app/app_screens/main_screen.dart';

import 'main_screen.dart';

Future<User> createUser(String username) async {
  final http.Response response = await http.post(
    'https://jsonplaceholder.typicode.com/users',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
    }),
  );

  if (response.statusCode == 201) {
    return User.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create user.');
  }
}

class log_in extends StatefulWidget {
  log_in({Key key}) : super(key: key);

  @override
  _log_in_State createState() {
    return _log_in_State();
  }
}

class _log_in_State extends State<log_in> {
  Future<User> _futureUser;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  Icon submit_btn_icn = Icon(Icons.done);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Card(
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
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
                      onPressed: () {
                        submit_btn_icn = Icon(Icons.done_all);

                        _futureUser = createUser(_username.text);
                        _futureUser.then((resp) {
                          if (resp != null) {
                            AlertDialog(content: Text(resp.username));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainScreen()));
                          } else {
                            AlertDialog(
                              title: Text('Error'),
                              content: Text('user not found'),
                            );
                          }
                        });
                      },
                      color: Theme.of(context).backgroundColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(1.0))),
                  Text(''),
                ],
              )),
        ),
      ),
    );
  }
}

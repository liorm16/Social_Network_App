import 'dart:convert';

import 'package:daesh_app/app_screens/log_in.dart';
import 'package:daesh_app/app_screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostForm extends StatefulWidget {
  int userId;

  PostForm();

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final TextEditingController _content = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int userId;

  _PostFormState();

  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if (jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    print('building postform');
    return FutureBuilder(
        future: jwtOrEmpty,
        // ignore: missing_return
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return log_in();
          }
          if (snapshot.data != "") {
            return SafeArea(
                child: Scaffold(
                    backgroundColor: Theme
                        .of(context)
                        .backgroundColor,
                    body: Center(
                        child: Container(
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Theme
                                    .of(context)
                                    .backgroundColor,
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
                                color: Theme
                                    .of(context)
                                    .cardColor,
                                child: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        ListTile(
                                          title: Text('Create Post',
                                              textScaleFactor: 2.0),
                                          trailing: RaisedButton(
                                              child: Icon(Icons.arrow_forward),
                                              color: Theme.of(context)
                                                  .buttonColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          5.0)),
                                              onPressed: () {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(builder:
                                                        (BuildContext context) {
                                                  return MainScreen();
                                                }));
                                              }),
                                        ),
                                        TextFormField(
                                          controller: _content,
                                          decoration: InputDecoration(
                                            hintText: 'Post Content',
                                            icon: Icon(Icons.text_fields),
                                          ),
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            return null;
                                          },
                                        ),
                                        RaisedButton(
                                            child: Icon(Icons.send),
                                            color: Theme.of(context)
                                                .buttonColor,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        1.0)),
                                            onPressed: () {
                                              sendPost(context, snapshot.data,
                                                  _content.text);
                                              Navigator.pushReplacement(context,
                                                  MaterialPageRoute(builder:
                                                      (BuildContext context) {
                                                return MainScreen();
                                              }));
                                            })
                                      ],
                                    )))))));
          } else {
            return log_in();
          }
        });
  }

  Future<void> sendPost(
      BuildContext context, String jwt, String content) async {
    var responseUser = await http
        .post(serverip + "/login/token", headers: {'Authorization': jwt});
    if (responseUser.statusCode == 200) {
      List userid = getUserFromJson(json.decode(responseUser.body));
      print(userid);
      Map data = {
        "post": {"userId": userid[0], "content": content}
      };
      var body = json.encode(data);
      print(body);
      var res = await http.post(serverip + "/posts",
          headers: {"Content-Type": "application/json"}, body: body);
      if (res.statusCode == 200) {
        print(res.statusCode);
      } else if (res.statusCode == 400) {
        displayDialog(context, res.body, "");
        print(res.statusCode);
      }
    } else {
      //displayDialog(context, responseUser.body, "error");
    }
  }
}

getUserFromJson(Map<String, dynamic> data) {
  // print(data);
  List<dynamic> user = new List(2);
  user[0] = data['id'];
  return user;
}

import 'dart:convert';

import 'package:daesh_app/widgets/post.dart';
import 'package:daesh_app/widgets/post_form.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'log_in.dart';


// ignore: must_be_immutable
class Home extends StatefulWidget {
  Home();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _HomeState();


  @override
  Widget build(BuildContext context) {
    print('building home');
    return FutureBuilder(
        future: jwtOrEmpty,
        // ignore: missing_return
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return log_in();
          }
          if (snapshot.data != "") {
            return Scaffold(
              backgroundColor: Theme
                  .of(context)
                  .primaryColor,
              appBar: AppBar(
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () {
                      storage.delete(key: 'jwt');
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return log_in();
                          }));
                    },
                    color: Theme
                        .of(context)
                        .backgroundColor,
                    splashColor: Theme
                        .of(context)
                        .primaryColor,
                  ),
                ],
                backgroundColor: Theme
                    .of(context)
                    .primaryColor,
                bottom: PreferredSize(
                    child: Container(color: Colors.black, height: 1.0,),
                    preferredSize: Size.fromHeight(4.0)),
                elevation: 5.0,
                leading: Text(''),
                title: Text("Home"),
                centerTitle: true,

              ),
              body: setPostFeed(snapshot.data),
            );
          } else {
            return log_in();
          }
        });
  }

  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if (jwt == null) return "";
    return jwt;
  }

  setPostFeed(String jwt) {
    return FutureBuilder<List<Post>>(
      future: pullPostFeed(jwt),
      builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          int length = snapshot.data.length;
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: length,
            itemBuilder: (BuildContext context, int index) {
              return snapshot.data[index];
            },
          );
        } else if (snapshot.hasError) {
          print('this is error');
        } else {
          //print('this is waiting');
        }
        return Text("");
      },
    );
  }

  Future<List<Post>> pullPostFeed(String jwt) async {
    var responseUser = await http
        .post(serverip + "/login/token", headers: {'Authorization': jwt});
    if (responseUser.statusCode == 200) {
      List userid = getUserFromJson(json.decode(responseUser.body));
      var response = await http.get(serverip + "/posts");
      List<dynamic> decodedList = json.decode(response.body);
      List<Post> postFeed = new List(decodedList.length);
      int length = decodedList.length;
      if (response.statusCode == 200) {
        for (int i = 0; i < length; i++) {
          postFeed[i] = Post.fromJSON(decodedList[i], userid[0]);
        }
        return postFeed;
      } else {
        displayDialog(context, response.body, "error in home posts");
      }
    } else {
      displayDialog(context, responseUser.body, "error in home user");
    }
  }


}

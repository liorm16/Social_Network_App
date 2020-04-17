import 'dart:convert';
import 'dart:typed_data';

import 'package:daesh_app/app_screens/log_in.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostHeader extends StatelessWidget {
  String time;
  int ownerId;

  PostHeader(String time, int ownerId) {
    this.time = time;
    this.ownerId = ownerId;
  }

  @override
  Widget build(BuildContext context) {
    return postInfo(context, time, ownerId);
  }

  postInfo(BuildContext context, String date, int ownerId) {
    return FutureBuilder<List<String>>(
        future: getUser(ownerId),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          ListTile postHeader;
          if (snapshot.hasData) {
            postHeader = ListTile(
              leading: createAvatar(context, snapshot.data[0], ownerId),
              title: createName(snapshot.data[1]),
              trailing: createTimePosted(time),
            );
          } else if (snapshot.hasError) {
            postHeader = ListTile(
              leading: Text('leading'),
              title: createName("Error"),
              trailing: createTimePosted(time),
            );
          } else {
            postHeader = ListTile(
              leading: DecoratedBox(
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Text('')),
              title: createName(""),
              trailing: createTimePosted(time),
            );
          }
          return postHeader;
        });
  }

  getUserFromJson(Map<String, dynamic> data) {
    // print(data);
    List<String> user = new List(2);
    user[0] = data['avatar'];
    user[1] = data['name'];
    return user;
  }

  Future<List<String>> getUser(int ownerId) async {
    var response = await http.get(serverip + "/users/" + ownerId.toString());
    if (response.statusCode == 200) {
      return getUserFromJson(json.decode(response.body));
    } else {}
  }

  createAvatar(BuildContext context, avatar_base64, int ownerId) {
    Uint8List bytes = base64Decode(avatar_base64.split(',').last);

    return CircleAvatar(
      radius: 25.0,
      backgroundImage: MemoryImage(bytes),
      backgroundColor: Colors.transparent,
    );
  }

  createName(String name) {
    return Text(name);
  }

  createTimePosted(String date) {
    return Text(
      date,
      textScaleFactor: 0.9,
    );
  }
}

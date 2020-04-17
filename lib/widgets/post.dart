// ignore: avoid_web_libraries_in_flutter
//import 'dart:html';

import 'dart:async';

import 'package:daesh_app/app_screens/log_in.dart';
import 'package:daesh_app/app_screens/main_screen.dart';
import 'package:daesh_app/widgets/post_button_bar.dart';
import 'package:daesh_app/widgets/post_header.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Post extends StatefulWidget {
  final String time;
  final String content;
  final postId;
  final ownerId;
  final currentUserId;


  Post(
      {this.time, this.content, this.postId, this.ownerId, this.currentUserId});

  factory Post.fromJSON(Map<String, dynamic> data, int currentUserId) {
    return Post(
      content: data['content'],
      time: data['createdAt'],
      ownerId: data['userId'],
      postId: data['id'],
      currentUserId: currentUserId,
    );
  }

  @override
  _PostState createState() =>
      _PostState(this.content, this.time, this.postId, this.ownerId,
          this.currentUserId);
}

class _PostState extends State<Post> {
  String content;
  String time;
  int postId;
  int ownerId;
  PostHeader postHeader;
  int currentUserId;

  PostButtonBar btnBar;

  _PostState(String content, String time, int postId, int ownerId,
      int currentUserId) {
    this.content = content;
    this.ownerId = ownerId;
    this.postId = postId;
    this.time = time;
    this.postHeader = new PostHeader(time, ownerId);
    this.btnBar = new PostButtonBar(ownerId, postId);
    this.currentUserId = currentUserId;
  }


  var _tapPosition;

  void _showCustomMenu() {
    final RenderBox overlay = Overlay
        .of(context)
        .context
        .findRenderObject();

    showMenu(
        context: context,
        items: <PopupMenuEntry<int>>[Entry(currentUserId, postId, ownerId)],
        position: RelativeRect.fromRect(
            _tapPosition & Size(40, 40),
            Offset.zero & overlay.size
        )
    )
        .then<void>((int delta) {
      if (delta == null) return;
      setState(() {});
    });
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Theme
                .of(context)
                .backgroundColor,
            borderRadius: BorderRadius.circular(1.5),
            boxShadow: [
              BoxShadow(
                color: Theme
                    .of(context)
                    .backgroundColor,
                blurRadius: 3.0,
                spreadRadius: 3.0, // has the effect of extending the shadow
                offset: Offset(
                  4.0, // horizontal, move right 10
                  4.0, // vertical, move down 10
                ),
              ),
            ]),
        child: Card(
          color: Theme
              .of(context)
              .cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1.5),
          ),
          elevation: 10.0,
          child: InkWell(
              splashColor: Theme
                  .of(context)
                  .primaryColor,
              onLongPress: _showCustomMenu,
              onTapDown: _storePosition,
              onTap: () {

              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  postHeader,
                  Divider(
                    thickness: 1.0,
                    height: 10.0,
                    indent: 10.0,
                    endIndent: 10.0,
                  ),
                  postContent(content),
                  Divider(
                    thickness: 1.0,
                    height: 10.0,
                    indent: 10.0,
                    endIndent: 10.0,
                  ),
                  btnBar
                ],
              )),
        ));
  }

//////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////

  postContent(String content) {
    return Text(content, textAlign: TextAlign.center, textScaleFactor: 1.5);
  }
}

class Entry extends PopupMenuEntry<int> {
  int postOwnerId;
  int currentUserId;
  int postId;
  double height = 100;

  Entry(int currentUserId, int postId, int postOwnerId) {
    this.postOwnerId = postOwnerId;
    this.currentUserId = currentUserId;
    this.postId = postId;
  }

  @override
  EntryState createState() =>
      EntryState(this.currentUserId, this.postId, this.postOwnerId);

  @override
  bool represents(int value) {
    // TODO: implement represents
    return false;
  }


}

class EntryState extends State<Entry> {
  int currentUserId;
  int postId;
  int postOwnerId;

  EntryState(int currentUserId, int postId, int postOwnerId) {
    this.postOwnerId = postOwnerId;
    this.currentUserId = currentUserId;
    this.postId = postId;
  }

  Future<void> deletePost() async {
    var res = await http.delete(serverip + "/posts/" + postId.toString());
    if (res.statusCode == 200) {

    } else if (res.statusCode == 400) {
      displayDialog(context, res.body, "");
    } else {
      print('else');
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) {
      return MainScreen();
    }));
  }

  void _minus1() {
  }

  @override
  Widget build(BuildContext context) {
    if (postOwnerId == currentUserId) {
      return Row(
        mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
            child: FlatButton(onPressed: deletePost, child: Text('Delete'))),
        Expanded(child: FlatButton(onPressed: _minus1, child: Text('Update'))),
      ],
    );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(child: FlatButton(onPressed: () {
            setState(() {
              deletePost();
            });
          }, child: Text('info'))),
          Expanded(child: FlatButton(onPressed: _minus1, child: Text(''))),
        ],
      );
    }
  }
}
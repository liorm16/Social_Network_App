import 'dart:convert';
import 'dart:io' as Io;

import 'package:flutter/material.dart';

class Comment extends StatefulWidget {
  String comment;

  //final int ownerId;
  //final int postId;
  String avatar;
  String name;
  int ownerId;

  Comment(String comment, String avatar, String name, int ownerId) {
    this.comment = comment;
    this.avatar = avatar;
    this.name = name;
    this.ownerId = ownerId;
  }

  @override
  _CommentState createState() => _CommentState(
    //img: this.img,
      avatar: this.avatar,
      name: this.name,
      comment: this.comment,
      ownerId: this.ownerId);
}

class _CommentState extends State<Comment> {
  final String comment;
  final int ownerId;

  //final int ownerId;
  //final int postId;
  final String avatar;
  final String name;

  _CommentState({this.comment, this.avatar, this.name, this.ownerId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(0.2),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ListTile(
            leading: createAvatar(avatar, ownerId),
            title: Text(name),
          ),
          Text(comment)
        ],
      ),
    );
  }

  createAvatar(String avatar, int ownerId) {
    final decodedBytes = base64Decode(avatar);
    var fileAvatar = Io.File("postAvatar" + ownerId.toString() + ".png");
    fileAvatar.writeAsBytesSync(decodedBytes);
    return BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(fit: BoxFit.fill, image: FileImage(fileAvatar)));
  }
}

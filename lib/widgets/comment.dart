import 'package:flutter/material.dart';

class Comment extends StatefulWidget {
  String comment;

  //final int ownerId;
  //final int postId;
  String avatar;
  String name;

  Comment(String comment, String avatar, String name) {
    this.comment = comment;
    this.avatar = avatar;
    this.name = name;
  }

  @override
  _CommentState createState() => _CommentState(
        //img: this.img,
        avatar: this.avatar,
        name: this.name,
        comment: this.comment,
      );
}

class _CommentState extends State<Comment> {
  final String comment;

  //final int ownerId;
  //final int postId;
  final String avatar;
  final String name;

  _CommentState({this.comment, this.avatar, this.name});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(0.2),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[ListTile(), Text(comment)],
      ),
    );
  }
}

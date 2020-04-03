import 'package:flutter/material.dart';
import 'package:daesh_app/widgets/comment.dart';

class CommentWindow extends StatefulWidget {
  int ownerId;
  int postId;
  List<Comment> commentList;
  Duration duration = Duration(milliseconds: 150);

  CommentWindow(int ownerId, int postId, List<Comment> commentList) {
    this.commentList = commentList;
    this.ownerId = ownerId;
    this.postId = postId;
  }

  @override
  _CommentWindow createState() => _CommentWindow(
        commentList: this.commentList,
        postId: this.postId,
        ownerId: this.ownerId,
      );
}

class _CommentWindow extends State<CommentWindow> {
  Duration _duration = Duration(milliseconds: 300);
  List<Comment> commentList;
  final ownerId;
  final postId;

  _CommentWindow({this.ownerId, this.postId, this.commentList});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        //ListViewEffect(duration: _duration, children: commentList.map((s) => Comment(s,)).toList())
      ],
    );
  }
}

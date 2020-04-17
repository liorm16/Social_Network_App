import 'package:daesh_app/widgets/comment.dart';
import 'package:flutter/material.dart';

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
  int ownerId;
  int postId;

  _CommentWindow({this.ownerId, this.postId, this.commentList});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Stack(
      children: <Widget>[

      ],
        )
    );
  }
}

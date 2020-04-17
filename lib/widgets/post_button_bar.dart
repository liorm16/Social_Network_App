import 'dart:convert';

import 'package:daesh_app/app_screens/log_in.dart';
import 'package:daesh_app/widgets/comment.dart';
import 'package:daesh_app/widgets/share_Window.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'comment_Window.dart';
// ignore: must_be_immutable

class PostButtonBar extends StatefulWidget {
  final int ownerId;
  final int postId;
  bool isLiked;

  PostButtonBar(this.ownerId, this.postId);

  @override
  _PostButtonBarState createState() =>
      _PostButtonBarState(this.ownerId, this.postId);
}

class _PostButtonBarState extends State<PostButtonBar> {
  int ownerId;
  bool isLiked;
  int postId;

  _PostButtonBarState(int ownerId, int postId) {
    this.ownerId = ownerId;
    this.postId = postId;
    this.isLiked = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return createButtonBar(ownerId, postId);
  }

  createButtonBar(int ownerId, int postId) {
    return ButtonBar(
      alignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        buildLikeButton(ownerId, postId),
        createCommentButton(),
        createShareButton(),
      ],
    );
  }

  buildLikeButton(int ownerId, int postId) {
    IconButton likeButton;
    return FutureBuilder<bool>(
        future: getLike(ownerId, postId),
        // ignore: missing_return
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            isLiked = snapshot.data;
          } else if (snapshot.hasError) {
            isLiked = false;
          } else {
            isLiked = false;
          }
          likeButton = createLikeButton(ownerId, postId);
          return likeButton;
        });
  }

  Future<bool> getLike(int ownerId, int postId) async {
    var response = await http.get(serverip +
        "/likes?userId=" +
        ownerId.toString() +
        "&postId=" +
        postId.toString());
    if (response.statusCode == 200) {
      if (json.decode(response.body).length == 0) {
        return false;
      }
      return true;
    } else {
      return false;
    }
  }

  createLikeButton(int ownerId, int postId) {
    return IconButton(
      icon: returnLikeIcon(),
      color: Theme.of(context).accentColor,
      onPressed: () {
        if (this.mounted) {
          Future lol = likePress(ownerId, postId);
        }
      },
    );
  }

  Future<void> likePress(int ownerId, int postId) async {
    var response = await http.post(serverip +
        "/likes?userId=" +
        ownerId.toString() +
        "&postId=" +
        postId.toString());
    //print(response.statusCode);
    if (response.statusCode == 201) {
      //print(response.statusCode);
      setState(() {
        isLiked = true;
      });
      //return isLiked;
    } else if (response.statusCode == 200) {
      //print(response.statusCode);
      setState(() {
        isLiked = false;
      });
      //return isLiked;
    } else {
      setState(() {
        isLiked = false;
      });
      //return isLiked;
    }
  }

  returnLikeIcon() {
    if (isLiked) {
      return Icon(Icons.favorite, color: Theme.of(context).primaryColor);
    } else {
      return Icon(Icons.favorite_border, color: Theme.of(context).primaryColor);
    }
  }

  createCommentButton() {
    return GestureDetector(
      onTap: openCommentWindow(ownerId, postId),
      child: Icon(Icons.comment),
    );
  }

  openCommentWindow(int ownerId, int postId) {
    CommentWindow(ownerId, postId, createCommentList(ownerId, postId));
  }

  createCommentList(int ownerId, int postId) {
    List<Comment> commentList = [Comment("lol", "123", "23", 123)];
    return commentList;
  }

  createShareButton() {
    return GestureDetector(
      onTap: openShareWindow(ownerId, postId),
      child: Icon(Icons.share),
    );
  }

  openShareWindow(int ownerId, int postId) {
    ShareWindow();
  }
}

import 'dart:html';
import 'package:flutter/material.dart';
import 'package:daesh_app/const_data/const.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:io' as Io;
import 'package:daesh_app/widgets/comment_Window.dart';
import 'package:daesh_app/widgets/share_Window.dart';
import 'package:daesh_app/widgets/comment.dart';

class Post extends StatefulWidget {
  final String avatar;
  final String name;
  final DateTime time;

  //final String img;
  final String content;
  final int likes;
  final postId;
  final ownerId;
  bool isLiked;

  Post({this.avatar,
    this.name,
    this.time,
    //this.img,
    this.likes,
    this.isLiked,
    this.content,
    this.postId,
    this.ownerId});

  factory Post.fromJSON(Map data) {
    return Post(
      name: data['name'],
      avatar: data['avatar'],
      //img: data['img'],
      likes: data['likes'],
      isLiked: data['isLiked'],
      content: data['content'],
      time: data['time'],
      ownerId: data['ownerId'],
      postId: data['postId'],
    );
  }

  @override
  _PostState createState() =>
      _PostState(
        //img: this.img,
        avatar: this.avatar,
        name: this.name,
        content: this.content,
        time: this.time,
        likes: this.likes,
        isLiked: this.isLiked,
        ownerId: this.ownerId,
        postId: this.postId,
      );
}

class _PostState extends State<Post> {
  final String avatar;

  //final String img;
  final String name;
  final String content;
  final DateTime time;
  int likes;
  bool isLiked;
  final int postId;
  final int ownerId;

  _PostState({ //this.img,
    this.avatar,
    this.name,
    this.content,
    this.time,
    this.likes,
    this.postId,
    this.isLiked,
    this.ownerId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(0.2),
      child: Container(
          child: Row(
            children: <Widget>[
              postInfo(context, avatar, time, name, ownerId),
              Divider(
                thickness: 0.2,
                height: 0.3,
              ),
              postContent(content),
              createButtonBar(isLiked, likes, ownerId, postId),
            ],
          )),
    );
  }

//////////////////////////////////////////////////////////////////////////////////////////
  postInfo(BuildContext context, String avatar, DateTime date, String name,
      int ownerId) {
    return ListTile(
      leading: createAvatar(context, avatar, ownerId),
      title: createName(name),
      trailing: createTimePosted(date),
    );
  }

  createAvatar(BuildContext context, String avatar, int ownerId) {
    final decodedBytes = base64Decode(avatar);
    var fileAvatar = Io.File("postAvatar" + ownerId.toString() + ".png");
    fileAvatar.writeAsBytesSync(decodedBytes);
    return BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(fit: BoxFit.fill, image: FileImage(fileAvatar)));
  }

  createName(String name) {
    return Text(name);
  }

  createTimePosted(DateTime date) {
    return Text(date.toUtc().toIso8601String());
  }

//////////////////////////////////////////////////////////////////////////////////////////

  postContent(String content) {
    return Text(content);
  }

  createButtonBar(bool isLiked, int likes, int ownerId, int PostId) {
    return ButtonBar(
      alignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        createLikeButton(isLiked, likes, ownerId, postId),
        createCommentButton(),
        createShareButton(),
      ],
    );
  }

  createLikeButton(bool isLiked, int likes, int ownerId, int postId) {
    Icon like;
    if (isLiked) {
      like = Icon(Icons.favorite);
    } else {
      like = Icon(Icons.favorite_border);
    }
    return GestureDetector(
        onTap: () {
          setState(() {
            likePress(isLiked, ownerId, postId, like);
          });
        },
        child: Container(
            child: Row(children: <Widget>[
              IconButton(
                icon: like,
                color: Theme
                    .of(context)
                    .accentColor,
                onPressed: () {},
              ),
              Text(likes.toString())
            ])));
  }

  likePress(bool isLiked, int ownerId, int postId, Icon like) async {
    final http.Response response = await http.post("url/like/user_id=:" +
        ownerId.toString() +
        "&post_id=:" +
        postId.toString());
    if (response.body == "Created") {
      isLiked = true;
      like = Icon(Icons.favorite);
    } else if (response.body == "OK") {
      isLiked = false;
      like = Icon(Icons.favorite_border);
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
    List <Comment> commentList = [Comment("lol", "123", "23")];
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

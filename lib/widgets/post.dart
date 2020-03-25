import 'package:flutter/material.dart';
import 'package:daesh_app/const_data/const.dart';

class Post extends StatefulWidget {
  final String avatar;
  final String name;
  final String time;
  final String img;
  final String vid;
  final String txt;
  final String likes;

  Post({
    Key key,
    @required this.avatar,
    @required this.name,
    @required this.time,
    @required this.img,
    @required this.txt,
    this.vid,
    this.likes,
  }) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  bool liked;

  Widget build(BuildContext context) {
    liked = false;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(
                  "${widget.avatar}",
                ),
              ),
              contentPadding: EdgeInsets.all(0),
              title: Text(
                "${widget.name}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                "${widget.time}",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 11,
                ),
              ),
            ),
            Text("${widget.txt}"),
            Image.asset(
              "${widget.img}",
              height: 170,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: buildLikeIcon()
              //RaisedButton(
              //color: Theme.of(context).backgroundColor,
              //shape: RoundedRectangleBorder(
              //    borderRadius: new BorderRadius.circular(1.0),
              //   side: BorderSide(color: Colors.white)),
              //child: Icon(Icons.thumb_up),
              //onPressed: () => likeBtnAction(context),
              ,
              title: RaisedButton(
                  onPressed: () => commentBtnAction(context),
                  color: Theme.of(context).backgroundColor,
                  child: Icon(Icons.comment),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(1.0))),
              trailing: RaisedButton(
                onPressed: () {},
                color: Theme.of(context).backgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(1.0),
                    side: BorderSide(color: Colors.white)),
                child: Icon(Icons.share),
              ),
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }

  static void commentBtnAction(BuildContext context) {}

  GestureDetector buildLikeIcon() {
    Color color;
    IconData icon;

    if (liked) {
      color = Colors.pink;
      icon = Icons.thumb_up;
    } else {
      icon = Icons.thumb_up;
    }

    return GestureDetector(
        child: Icon(
          icon,
          size: 25.0,
          color: color,
        ),
        onTap: () {
          liked = true;
          // _likePost(postId);
        });
  }
}

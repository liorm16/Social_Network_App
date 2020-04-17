import 'package:flutter/material.dart';

class CommentWindow extends StatefulWidget {
  int ownerId;
  int postId;


  CommentWindow(int ownerId, int postId) {
    this.ownerId = ownerId;
    this.postId = postId;
  }

  @override
  _CommentWindow createState() => _CommentWindow(
        postId: this.postId,
        ownerId: this.ownerId,
      );
}

class _CommentWindow extends State<CommentWindow> {
  int ownerId;
  int postId;
  int initialDragTimeStamp;
  int currentDragTimeStamp;
  int timeDelta;
  double initialPositionY;
  double currentPositionY;
  double positionYDelta;

  _CommentWindow({this.ownerId, this.postId});


  void _startVerticalDrag(details) {
    // Timestamp of when drag begins
    initialDragTimeStamp = details.sourceTimeStamp.inMilliseconds;

    // Screen position of pointer when drag begins
    initialPositionY = details.globalPosition.dy;
  }

  void _whileVerticalDrag(details) {
    // Gets current timestamp and position of the drag event
    currentDragTimeStamp = details.sourceTimeStamp.inMilliseconds;
    currentPositionY = details.globalPosition.dy;

    // How much time has passed since drag began
    timeDelta = currentDragTimeStamp - initialDragTimeStamp;

    // Distance pointer has travelled since drag began
    positionYDelta = currentPositionY - initialPositionY;

    // If pointer has moved more than 50pt in less than 50ms...
    if (timeDelta < 50 && positionYDelta > 50) {
      // close modal
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onVerticalDragStart: (details) => _startVerticalDrag(details),
        onVerticalDragUpdate: (details) => _whileVerticalDrag(details),
        child: Stack(
          children: <Widget>[
            Opacity(child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
            ), opacity: 0.1,),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment:
              MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.center,
              children: <Widget>[
              ],),
          ],
        )
    );
  }
}

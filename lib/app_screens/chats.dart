import 'package:flutter/material.dart';

class Chats extends StatefulWidget {
  Chats();

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  _ChatsState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        bottom: PreferredSize(
            child: Container(
              color: Colors.black,
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(4.0)),
        elevation: 5.0,
        leading: Text(''),
        title: Text("Chats"),
        centerTitle: true,
      ),
      body: setChats('jwt'),
    );
  }

  setChats(String s) {}
}

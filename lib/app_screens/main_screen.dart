import 'package:daesh_app/app_screens/Home.dart';
import 'package:daesh_app/widgets/chat.dart';
import 'package:daesh_app/widgets/post.dart';
import 'package:daesh_app/widgets/post_form.dart';
import 'package:flutter/material.dart';

import 'Profile.dart';
import 'chats.dart';
import 'log_in.dart';

class MainScreen extends StatefulWidget {
  String jwt;
  List<Post> postFeed;
  List<Chat> chats;

  MainScreen();

  @override
  _MainScreenState createState() =>
      _MainScreenState(
      );
}

class _MainScreenState extends State<MainScreen> {
  String jwt;
  Home homePostFeed;
  PageController _pageController;
  PostForm postForm;
  int _page = 1;
  Duration pageChanging = Duration(milliseconds: 300);
  Curve animationCurve = Curves.linear;


  _MainScreenState() {
    this.homePostFeed = Home();
    this.postForm = PostForm();
  }

  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if (jwt == null) return "";
    return jwt;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
  }

  @override
  Widget build(BuildContext context) {
    //if jwt is empty go to login
    return FutureBuilder(
        future: jwtOrEmpty,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return log_in();
          }
          if (snapshot.data != "") {
            return Scaffold(
              body: PageView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                onPageChanged: onPageChanged,
                children: <Widget>[
                  Chats(),
                  homePostFeed,
                  Profile(),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: Theme
                    .of(context)
                    .backgroundColor,
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                          return postForm;
                        },
                        fullscreenDialog: true,
                      ));
                },
              ),
              bottomNavigationBar: Theme(
                data: Theme.of(context).copyWith(
                  // sets the background color of the `BottomNavigationBar`
                  canvasColor: Theme
                      .of(context)
                      .primaryColor,
                  // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                  primaryColor: Theme
                      .of(context)
                      .accentColor,
                  textTheme: Theme
                      .of(context)
                      .textTheme
                      .copyWith(
                    caption: TextStyle(color: Colors.grey[500]),
                  ),
                ),
                child: BottomNavigationBar(
                  elevation: 5.0,
                  type: BottomNavigationBarType.fixed,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.message,
                      ),
                      title: Container(height: 0.0),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home,
                      ),
                      title: Container(height: 0.0),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.person,
                      ),
                      title: Container(height: 0.0),
                    ),
                  ],
                  onTap: navigationTapped,
                  selectedItemColor: Theme
                      .of(context)
                      .backgroundColor,
                  currentIndex: _page,
                ),
              ),
            );
          } else {
            return log_in();
          }
        }
    );
  }

  void navigationTapped(int page) {
    _pageController.animateToPage(
      page,
      duration: pageChanging,
      curve: animationCurve,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    if (this.mounted) {
      setState(() {
        this._page = page;
      });
    }
  }
}

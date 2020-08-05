import 'package:duochat/screens/profile_page.dart';
import 'package:flutter/material.dart';

import 'find_friends_page.dart';
import 'home_page.dart';

class HomeScreenContainer extends StatefulWidget {
  static String id = 'home_screen';

  @override
  _HomeScreenContainerState createState() => _HomeScreenContainerState();
}

class _HomeScreenContainerState extends State<HomeScreenContainer> {
  final _pageController = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: <Widget>[
        ProfilePage(),
        HomePage(),
        FindFriendsPage(),
      ],
    );
  }
}

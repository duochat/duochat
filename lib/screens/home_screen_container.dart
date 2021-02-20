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
  int currentPage = 1;
  final _pageController = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          ProfilePage(),
          HomePage(),
          FindFriendsPage(),
        ],
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });
        }
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (index) {
          currentPage = index;
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: currentPage == 0 ? Colors.orange : Colors.grey,
            ),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: currentPage == 1 ? Colors.orange : Colors.grey,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: currentPage == 2 ? Colors.orange : Colors.grey,
            ),
            label: "Connections",
          ),
        ],
      ),
    );
  }
}

import 'package:duochat/widget/floating_bottom_button.dart';
import 'package:flutter/material.dart';

class FindFriendsPage extends StatefulWidget {
  @override
  _FindFriendsPageState createState() => _FindFriendsPageState();
}

class _FindFriendsPageState extends State<FindFriendsPage> {
  void _showSearchScreen(context) {
//    showSearch(context: context, delegate: UserSearch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                    child: Icon(
                      Icons.search,
                      color: Colors.black87,
                      size: 24.0,
                    ),
                  ),
                  prefixIconConstraints: BoxConstraints(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                  isDense: true,
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(200.0)),
                  ),
                ),
                onChanged: (text) {
                  print('Search: $text');
                },
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'My Friends... show recommendations / incoming friend requests here?',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            FloatingBottomButton(
              onTap: () => _showSearchScreen(context),
              text: 'ADD FRIEND',
            ),
          ],
        ),
      ),
    );
  }
}

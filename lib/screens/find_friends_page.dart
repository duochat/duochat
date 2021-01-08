import 'package:duochat/widget/floating_bottom_button.dart';
import 'package:duochat/widget/user_search.dart';
import 'package:duochat/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:duochat/widget/top_nav_bar.dart';

class FindFriendsPage extends StatefulWidget {
  @override
  _FindFriendsPageState createState() => _FindFriendsPageState();
}

class _FindFriendsPageState extends State<FindFriendsPage> {
	
	UserSearch _searchDelegate = UserSearch();
	bool _isLoading = false;
	List<PublicUserData> _searchResults = <PublicUserData>[];
	
  void _showSearchScreen(context) {
    //showSearch(context: context, delegate: UserSearch());
  }

  @override
  Widget build(BuildContext context) {
  	//return Text('hi');
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
	      child: Column(
		      children: <Widget>[
			      TopNavBar(
				      image: NetworkImage('https://picsum.photos/200/200'),
				      title: 'Find Friends',
				      suffix: CupertinoButton(
					      onPressed: () {
						      print('idk what this button does');
					      },
					      child: Text(
						      'idk',
						      style: TextStyle(color: Colors.black87),
					      ),
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
					    onTap: () => showSearch(context: context, delegate: _searchDelegate),
					    text: 'FIND FRIEND',
				    ),
		      ],
	      ),
      ),
    );
  }
}

import 'package:duochat/widget/user_list.dart';
import 'package:duochat/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:duochat/widget/top_nav_bar.dart';

class FindFriendsPage extends StatefulWidget {
  @override
  _FindFriendsPageState createState() => _FindFriendsPageState();
}

class _FindFriendsPageState extends State<FindFriendsPage> {

	// mock data:
	final List<UserData> _users = [
		UserData(name: 'Kitty', id: '1', photoURL: 'https://i.imgur.com/O9z1hcx.png', username: 'ghost_cat'),
		UserData(name: 'Cat', id: '2', photoURL: 'https://i.imgur.com/UYcL5sl.jpg', username: 'paint_cat'),
		UserData(name: 'Space Planet', id: '3', photoURL: 'https://i.imgur.com/ftmga3Y.png', username: 'red_planet'),
		UserData(name: 'Space Galaxy', id: '4', photoURL: 'https://i.imgur.com/drDF2xB.jpg', username: 'milkyway'),
		UserData(name: 'Random Girl', id: '5', photoURL: 'https://i.imgur.com/6xFjIVa.jpg', username: 'commonapp_girl'),
		UserData(name: 'Dino', id: '6', photoURL: 'https://i.imgur.com/Vaoll5X.png', username: 'Dio'),
	];
	final List<UserData> _requests = [
	UserData(name: 'Kitty', id: '1', photoURL: 'https://i.imgur.com/O9z1hcx.png', username: 'ghost_cat'),
	UserData(name: 'Cat with a name so long the card expands (should this be legal?) also you can\'t see the username anymore lol', id: '2', photoURL: 'https://i.imgur.com/UYcL5sl.jpg', username: 'paint_cat_with_a_really_super_long_username'),
	UserData(name: 'Random Girl', id: '5', photoURL: 'https://i.imgur.com/6xFjIVa.jpg', username: 'commonapp_girl'),
	];

	bool _isSearching = false;
	List<UserData> _searchResults = <UserData>[];

	void _updateSearch(String keyword) {
		setState(() {
			// TODO: replace this with firebase integration
			_searchResults = _users
					.where((user) =>
			user.name.toLowerCase().contains(keyword.toLowerCase()) ||
					user.username.toLowerCase().contains(keyword.toLowerCase())).toList();
		});
	}
	
  void _showSearchBar() {
  	print("show search bar");
  	setState(() {
  		_searchResults = [];
  	  _isSearching = true;
  	});
  }

  void _hideSeachBar() {
		print("hide search bar");
  	setState(() {
			_searchResults = [];
  	  _isSearching = false;
  	});
	}

  @override
  Widget build(BuildContext context) {
  	//return Text('hi');
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
	      child: Column(
		      children: <Widget>[
		      	_isSearching
						? TopSearchBar(
								hint: "Find connections...",
								onChanged: _updateSearch,
								suffix: IconButton(
									icon: Icon(Icons.clear),
									tooltip: "Close",
									onPressed: _hideSeachBar,
								),
							)
						: TopNavBar(
								image: NetworkImage('https://picsum.photos/200/200'),
								title: _isSearching ? '' : 'Connection Requests',
								suffix: IconButton(
									icon: Icon(Icons.search),
									tooltip: "Find new connections",
									onPressed: _showSearchBar,
								)
			      	),
			      _isSearching
						? UserSearchList(results: _searchResults)
						: ConnectionRequestList(requests: _requests),
		      ],
	      ),
      ),
    );
  }
}

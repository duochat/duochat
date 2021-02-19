import 'package:duochat/widget/user_list.dart';
import 'package:duochat/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:duochat/widget/top_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class FindFriendsPage extends StatefulWidget {
  @override
  _FindFriendsPageState createState() => _FindFriendsPageState();
}

class _FindFriendsPageState extends State<FindFriendsPage> {

	// mock data: [
	// 		UserData(name: 'Kitty', id: '1', photoURL: 'https://i.imgur.com/O9z1hcx.png', username: 'ghost_cat'),
	// 		UserData(name: 'Cat', id: '2', photoURL: 'https://i.imgur.com/UYcL5sl.jpg', username: 'paint_cat'),
	// 		UserData(name: 'Space Planet', id: '3', photoURL: 'https://i.imgur.com/ftmga3Y.png', username: 'red_planet'),
	// 		UserData(name: 'Space Galaxy', id: '4', photoURL: 'https://i.imgur.com/drDF2xB.jpg', username: 'milkyway'),
	// 		UserData(name: 'Random Girl', id: '5', photoURL: 'https://i.imgur.com/6xFjIVa.jpg', username: 'commonapp_girl'),
	// 		UserData(name: 'Dino', id: '6', photoURL: 'https://i.imgur.com/Vaoll5X.png', username: 'Dio'),
	// 	][
	// 	PublicUserData(name: 'Kitty', id: '1', photoURL: 'https://i.imgur.com/O9z1hcx.png', username: 'ghost_cat'),
	// 	PublicUserData(name: 'Cat with a name so long the card expands (should this be legal?) also you can\'t see the username anymore lol', id: '2', photoURL: 'https://i.imgur.com/UYcL5sl.jpg', username: 'paint_cat_with_a_really_super_long_username'),
	// 	PublicUserData(name: 'Random Girl', id: '5', photoURL: 'https://i.imgur.com/6xFjIVa.jpg', username: 'commonapp_girl'),
	// 	]
	
	List<PublicUserData> _users = [];
	List<PublicUserData> _requests = [];

	bool _isSearching = false;
	List<PublicUserData> _searchResults = [];

	void initState() {
		super.initState();
		_updateRequests();
	}

	Future<void> _updateRequests() async {

		User firebaseUser = Provider.of<User>(context, listen: false);
		PrivateUserData requestsData = await PrivateUserData.fromID(firebaseUser.uid);
		QuerySnapshot snapshot = await FirebaseFirestore.instance
			.collection("publicUserInfo")
			.where('id', whereIn: requestsData.incomingRequests.toList())
			.get();
		print('updated ${snapshot}');
		setState(() {
			_requests = snapshot.docs.map((doc) => PublicUserData.fromMap(doc.data())).toList();
		});
	}

	void _updateSearch(String keyword) {
		setState(() {
			// TODO: replace this with firebase integration
			_searchResults = _users
					.where((user) =>
			user.name.toLowerCase().contains(keyword.toLowerCase()) ||
					user.username.toLowerCase().contains(keyword.toLowerCase())).toList();
		});
	}
	
  void _showSearchBar() async {
  	QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("publicUserInfo").get();
		_users = snapshot.docs.map((doc) => PublicUserData.fromMap(doc.data())).toList();

  	setState(() {
  		_searchResults = [];
  	  _isSearching = true;
  	});
  }

  void hideSearchBar() {
		print("hide search bar");
  	setState(() {
			_searchResults = [];
  	  _isSearching = false;
  	});
	}

  @override
  Widget build(BuildContext context) {
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
									onPressed: hideSearchBar,
								),
							)
						: TopNavBar(
								image: NetworkImage('https://picsum.photos/200/200'),
								title: _isSearching ? '' : 'Connections',
								suffix: IconButton(
									icon: Icon(Icons.search),
									tooltip: "Find new connections",
									onPressed: _showSearchBar,
								)
			      	),
			      _isSearching
						? UserSearchList(results: _searchResults)
						: ConnectionRequestList(
							requests: _requests,
							onRefresh: _updateRequests,
						),
		      ],
	      ),
      ),
    );
  }
}

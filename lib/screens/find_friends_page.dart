import 'package:duochat/screens/profile_screen.dart';
import 'package:duochat/screens/request_screen.dart';
import 'package:duochat/widget/user_card.dart';
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

	bool _isSearching = false;
	List<PublicUserData> _searchResults = [];
	
	List<GlobalKey<SlideInState>> _searchCardKeys = [];

	void _updateSearch(String keyword) async {

		_searchCardKeys.forEach((key) => key.currentState.slideOut());

		if(_searchResults.length > 0) {
			await Future.delayed(Duration(milliseconds: 200));
		}
		setState(() { _searchResults = []; });
		await Future.delayed(Duration(milliseconds: 10));
		setState(() {
			// TODO: replace this with firebase integration
			_searchResults = _users
					.where((user) =>
			user.name.toLowerCase().contains(keyword.toLowerCase()) ||
					user.username.toLowerCase().contains(keyword.toLowerCase())).toList();
			_searchCardKeys = List<GlobalKey<SlideInState>>();
			for(int i = 0; i < _searchResults.length; i++) {
				_searchCardKeys.add(GlobalKey<SlideInState>());
			}
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
						? _UserSearchList(results: _searchResults, userCardKeys: _searchCardKeys)
						: _ConnectionsList()
		      ],
	      ),
      ),
    );
  }
}

class _ConnectionsList extends StatefulWidget {

	@override
	State<StatefulWidget> createState() => _ConnectionsListState();
}

class _ConnectionsListState extends State<_ConnectionsList> {

	GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
	List<GlobalKey<SlideInState>> _userCardKeys = [];

	List<String> _incomingRequests = [];
	List<String> _outgoingRequests = [];
	List<PublicUserData> _connections = [];

	@override
	void initState() {
		super.initState();
		Future.delayed(Duration(milliseconds: 0), () {
			_refreshIndicatorKey.currentState.show();
		});
	}

	Future<void> _updateConnections() async {

		_userCardKeys.forEach((key) => key.currentState.slideOut());

		User firebaseUser = Provider.of<User>(context, listen: false);
		PrivateUserData requestsData = await PrivateUserData.fromID(firebaseUser.uid);
		PublicUserData connectionsData = await PublicUserData.fromID(firebaseUser.uid);
		QuerySnapshot connectionsSnapshot = await FirebaseFirestore.instance.collection("publicUserInfo")
				.where('id', whereIn: connectionsData.connections.toList()+['']).get();

		if(_connections.length + requestsRowCount() > 0) {
			await Future.delayed(Duration(milliseconds: 500));
		}
		setState(() {
			_incomingRequests = [];
			_outgoingRequests = [];
			_connections = [];
		});
		await Future.delayed(Duration(milliseconds: 10));
		setState(() {
			_incomingRequests = requestsData.incomingRequests.toList();
			_outgoingRequests = requestsData.outgoingRequests.toList();
			_connections = connectionsSnapshot.docs.map((doc) => PublicUserData.fromMap(doc.data())).toList();
			_userCardKeys = List<GlobalKey<SlideInState>>();
			for(int i = 0; i < _connections.length + requestsRowCount(); i++) {
				_userCardKeys.add(GlobalKey<SlideInState>());
			}
		});
	}

  int requestsRowCount() =>
			(_incomingRequests.isEmpty ? 0 : 1) + (_outgoingRequests.isEmpty ? 0 : 1);

	@override
	Widget build(BuildContext context) {
		return Expanded(
			child: RefreshIndicator(
				key: _refreshIndicatorKey,
				onRefresh: _updateConnections,
				child: ListView.builder(
					itemCount: _connections.length + requestsRowCount(),
					itemBuilder: (BuildContext context, int index) {
						if (index == 0 && _incomingRequests.isNotEmpty) {
							return SlideIn(
								key: _userCardKeys[index],
								delay: Duration(milliseconds: index*50),
								child: UserCard(
									user: PublicUserData(
										name: '${_incomingRequests
												.length} Incoming Request${_incomingRequests
												.length >
												1 ? 's' : ''}',
									),
									contextWidget: Icon(Icons.arrow_forward_ios_rounded),
									onTap: () => Navigator.pushNamed(
										context,
										IncomingRequestsScreen.id,
										arguments: RequestsScreenArguments(
											_refreshIndicatorKey.currentState.show,
										),
									),
								),
							);
						}
						if (((index == 0 && _incomingRequests.isEmpty)
								|| (index == 1 && _incomingRequests.isNotEmpty))
										&& _outgoingRequests.isNotEmpty) {
							return SlideIn(
								key: _userCardKeys[index],
								delay: Duration(milliseconds: index*50),
								child: UserCard(
									user: PublicUserData(
										name: '${_outgoingRequests
												.length} Outgoing Request${_outgoingRequests
												.length >
												1 ? 's' : ''}',
									),
									contextWidget: Icon(Icons.arrow_forward_ios_rounded),
									onTap: () => Navigator.pushNamed(
										context,
										OutgoingRequestsScreen.id,
										arguments: RequestsScreenArguments(
											_refreshIndicatorKey.currentState.show,
										),
									),
								),
							);
						}
						return SlideIn(
							key: _userCardKeys[index],
							delay: Duration(milliseconds: index*50),
							child: UserCard(
								user: _connections[index - requestsRowCount()],
								message: _connections[index - requestsRowCount()].username,
								onTap: () => Navigator.pushNamed(
									context,
									ProfileScreen.id,
									arguments: ProfileScreenArguments(
										_connections[index - requestsRowCount()],
										_refreshIndicatorKey.currentState.show,
									),
								),
							),
						);
					},
				),
			),
		);
	}

}

class _UserSearchList extends StatelessWidget {

	final List<GlobalKey<SlideInState>> userCardKeys;

	final List<PublicUserData> results;

	_UserSearchList({
		Key key,
		this.results,
		this.userCardKeys,
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Expanded(
			child: ListView.builder(
				itemCount: results.length,
				itemBuilder: (BuildContext context, int index) {
					return SlideIn(
						key: userCardKeys[index],
						duration: Duration(milliseconds: 100),
						delay: Duration(milliseconds: index*50),
					  child: UserCard(
					  	user: results[index],
					  	message: results[index].username,
					  	onTap: () => Navigator.pushNamed(
					  		context,
					  		ProfileScreen.id,
					  		arguments: ProfileScreenArguments(
					  			results[index],
									() {},
					  		),
					  	),
					  ),
					);
				},
			),
		);
	}

}
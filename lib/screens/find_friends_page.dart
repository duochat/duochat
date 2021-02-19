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
	List<PublicUserData> _incomingRequests = [];
	List<PublicUserData> _outgoingRequests = [];
	List<PublicUserData> _connections = [];

	bool _isSearching = false;
	List<PublicUserData> _searchResults = [];

	void initState() {
		super.initState();
		_updateConnections();
	}

	Future<void> _updateConnections() async {

		print('refreshing connections data...');
		User firebaseUser = Provider.of<User>(context, listen: false);
		PrivateUserData requestsData = await PrivateUserData.fromID(firebaseUser.uid);
		PublicUserData connectionsData = await PublicUserData.fromID(firebaseUser.uid);
			QuerySnapshot incomingRequestsSnapshot = await FirebaseFirestore.instance.collection("publicUserInfo")
				.where('id', whereIn: requestsData.incomingRequests.toList()+['']).get();
		QuerySnapshot outgoingRequestsSnapshot = await FirebaseFirestore.instance.collection("publicUserInfo")
				.where('id', whereIn: requestsData.outgoingRequests.toList()+['']).get();
		QuerySnapshot connectionsSnapshot = await FirebaseFirestore.instance.collection("publicUserInfo")
				.where('id', whereIn: connectionsData.connections.toList()+['']).get();
		setState(() {
			_incomingRequests = incomingRequestsSnapshot.docs.map((doc) => PublicUserData.fromMap(doc.data())).toList();
			_outgoingRequests = outgoingRequestsSnapshot.docs.map((doc) => PublicUserData.fromMap(doc.data())).toList();
			_connections = connectionsSnapshot.docs.map((doc) => PublicUserData.fromMap(doc.data())).toList();
		});
		print('refreshed');
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
						? _UserSearchList(results: _searchResults)
						: _ConnectionsList(
							connections: _connections,
							incomingRequests: _incomingRequests,
							outgoingRequests: _outgoingRequests,
							onRefresh: _updateConnections,
						)
		      ],
	      ),
      ),
    );
  }
}

class _ConnectionsList extends StatelessWidget {

	final List<PublicUserData> incomingRequests;
	final List<PublicUserData> outgoingRequests;
	final List<PublicUserData> connections;
	final Function onRefresh;

  const _ConnectionsList({
		Key key,
		this.connections,
		this.incomingRequests,
		this.outgoingRequests,
		this.onRefresh
  }) : super(key: key);

  int requestsRowCount() =>
			(incomingRequests.isEmpty ? 0 : 1) + (outgoingRequests.isEmpty ? 0 : 1);

	@override
	Widget build(BuildContext context) {
		return Expanded(
			child: RefreshIndicator(
				onRefresh: onRefresh,
			  child: ListView.builder(
			  	itemCount: connections.length + requestsRowCount(),
			  	itemBuilder: (BuildContext context, int index) {
			  		if(index == 0 && incomingRequests.isNotEmpty) {
			  			return UserCard(
			  				user: PublicUserData(
			  					photoURL: incomingRequests.first.photoURL,
			  					name: '${incomingRequests.length} Incoming Request${incomingRequests.length>1 ? 's' : ''}',
			  				),
			  				message: incomingRequests.map((user) => user.name).join(', '),
			  				onTap: () => Navigator.pushNamed(
			  					context,
			  					IncomingRequestsScreen.id,
			  					arguments: RequestsScreenArguments(
			  						requests: incomingRequests,
			  						onRefresh: onRefresh,
			  					),
			  				),
			  			);
			  		}
			  		if((index == 0 && incomingRequests.isEmpty)
			  			|| (index == 1 && incomingRequests.isNotEmpty)
			  			&& outgoingRequests.isNotEmpty) {
							return UserCard(
								user: PublicUserData(
									photoURL: outgoingRequests.first.photoURL,
									name: '${outgoingRequests.length} Outgoing Request${outgoingRequests.length>1 ? 's' : ''}',
								),
								message: outgoingRequests.map((user) => user.name).join(', '),
								// onTap: () => Navigator.push(
								// 		context,
								// 		MaterialPageRoute(builder: (context) => OutgoingRequestsScreen(
								// 			requests: outgoingRequests,
								// 			onRefresh: onRefresh,
								// 		))
								// ),
								onTap: () => Navigator.pushNamed(
									context,
									OutgoingRequestsScreen.id,
									arguments: RequestsScreenArguments(
										requests: outgoingRequests,
										onRefresh: onRefresh,
									),
								),
							);
			  		}
			  		return UserCard(
			  			user: connections[index - requestsRowCount()],
			  			message: connections[index - requestsRowCount()].username,
			  			onTap: () => Navigator.pushNamed(
			  				context,
			  				ProfileScreen.id,
			  				arguments: ProfileScreenArguments(
									user: connections[index - requestsRowCount()],
									onRefresh: onRefresh,
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

	final List<PublicUserData> results;
	final Function onRefresh;

	_UserSearchList({
		Key key,
		this.results,
		this.onRefresh,
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Expanded(
			child: ListView.builder(
				itemCount: results.length,
				itemBuilder: (BuildContext context, int index) {
					return UserCard(
						user: results[index],
						message: results[index].username,
						onTap: () => Navigator.pushNamed(
							context,
							ProfileScreen.id,
							arguments: ProfileScreenArguments(
								user: results[index],
								onRefresh: onRefresh,
							),
						),
					);
				},
			),
		);
	}

}
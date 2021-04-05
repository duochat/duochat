import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duochat/models.dart';
import 'package:duochat/screens/profile_screen.dart';
import 'package:duochat/screens/request_screen.dart';
import 'package:duochat/widget/top_nav_bar.dart';
import 'package:duochat/widget/user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FindFriendsPage extends StatefulWidget {
  @override
  _FindFriendsPageState createState() => _FindFriendsPageState();
}

class _FindFriendsPageState extends State<FindFriendsPage> {
  List<GlobalKey<SlideInState>> _searchCardKeys = [];
  final FocusNode searchBarFocusNode = FocusNode();

  List<PublicUserData> _users = [];
  bool _isSearching = false;
  List<PublicUserData> _searchResults = [];

  @override
  void dispose() {
    super.dispose();
    searchBarFocusNode.dispose();
  }

  void _updateSearch(String keyword) async {
    if (_searchResults.length > 0) {
      _searchCardKeys.forEach((key) => key.currentState?.slideOut());
      await Future.delayed(Duration(milliseconds: 200));
    }

    setState(() {
      _searchResults = [];
    });
    await Future.delayed(Duration(milliseconds: 10));
    setState(() {
      _searchResults = _users
          .where((user) =>
              user.name.toLowerCase().contains(keyword.toLowerCase()) ||
              user.username.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
      _searchCardKeys = List<GlobalKey<SlideInState>>();
      for (int i = 0; i < _searchResults.length; i++) {
        _searchCardKeys.add(GlobalKey<SlideInState>());
      }
    });
  }

  void _showSearchBar() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("publicUserInfo").get();
    _users =
        snapshot.docs.map((doc) => PublicUserData.fromMap(doc.data())).toList();

    _updateSearch('');
    setState(() {
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
                    focusNode: searchBarFocusNode,
                    hint: "Find connections...",
                    onChanged: _updateSearch,
                    suffix: IconButton(
                      icon: Icon(Icons.clear),
                      tooltip: "Close",
                      onPressed: hideSearchBar,
                    ),
                  )
                : TopNavBar(
                    image: AssetImage('graphics/logo.png'),
                    hasImageBorder: false,
                    title: _isSearching ? '' : 'Connections',
                    suffix: IconButton(
                      icon: Icon(Icons.search),
                      tooltip: "Find new connections",
                      onPressed: _showSearchBar,
                    )),
            _isSearching
                ? NotificationListener<ScrollStartNotification>(
                    child: _UserSearchList(
                        results: _searchResults, userCardKeys: _searchCardKeys),
                    onNotification: (notification) {
                      searchBarFocusNode.unfocus();
                      return true;
                    },
                  )
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
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<GlobalKey<SlideInState>> _userCardKeys = [];

  List<String> _incomingRequests = [];
  List<String> _outgoingRequests = [];
  List<String> _connectionSuggestions = [];
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

    final myID = FirebaseAuth.instance.currentUser.uid;
    PrivateUserData requestsData = await PrivateUserData.fromID(myID);
    PublicUserData connectionsData = await PublicUserData.fromID(myID);
    QuerySnapshot connectionsSnapshot = await FirebaseFirestore.instance
        .collection("publicUserInfo")
        .where('id', whereIn: connectionsData.connections.toList() + [''])
        .get();
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("publicUserInfo").get();
    final users =
        snapshot.docs.map((doc) => PublicUserData.fromMap(doc.data())).toList();

//    if (_connections.length + requestsRowCount() > 0) {
//      await Future.delayed(Duration(milliseconds: 500));
//    }
//    setState(() {
//      _incomingRequests = [];
//      _outgoingRequests = [];
//      _connectionSuggestions = [];
//      _connections = [];
//    });
//    await Future.delayed(Duration(milliseconds: 10));
    setState(() {
      _incomingRequests = requestsData.incomingRequests.toList();
      _outgoingRequests = requestsData.outgoingRequests.toList();
      _connectionSuggestions = [];
      users.forEach((user) {
        if (user.id == myID) return;
        if (requestsData.incomingRequests.contains(user.id) ||
            requestsData.outgoingRequests.contains(user.id) ||
            connectionsData.connections.contains(user.id)) return;
        final interests = connectionsData.interests
            .toLowerCase()
            .split(new RegExp("[,. /\n]+"));
        for (var interest
            in user.interests.toLowerCase().split(new RegExp("[,. /\n]+"))) {
          if (interests.contains(interest)) {
            _connectionSuggestions.add(user.id);
            break;
          }
        }
      });
      _connections = connectionsSnapshot.docs
          .map((doc) => PublicUserData.fromMap(doc.data()))
          .toList();
      _userCardKeys = List<GlobalKey<SlideInState>>();
      for (int i = 0; i < _connections.length + requestsRowCount(); i++) {
        _userCardKeys.add(GlobalKey<SlideInState>());
      }
    });
  }

  int requestsRowCount() =>
      (_incomingRequests.isEmpty ? 0 : 1) +
      (_outgoingRequests.isEmpty ? 0 : 1) +
      (_connectionSuggestions.isEmpty ? 0 : 1);

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
                delay: Duration(milliseconds: index * 50),
                child: UserCard(
                  user: PublicUserData(
                    name:
                        '${_incomingRequests.length} Incoming Request${_incomingRequests.length > 1 ? 's' : ''}',
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
            if (((index == 0 && _incomingRequests.isEmpty) ||
                    (index == 1 && _incomingRequests.isNotEmpty)) &&
                _outgoingRequests.isNotEmpty) {
              return SlideIn(
                key: _userCardKeys[index],
                delay: Duration(milliseconds: index * 50),
                child: UserCard(
                  user: PublicUserData(
                    name:
                        '${_outgoingRequests.length} Outgoing Request${_outgoingRequests.length > 1 ? 's' : ''}',
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
            if (((index == 0 && requestsRowCount() == 1) ||
                    (index == 1 && requestsRowCount() == 2) ||
                    (index == 2 && requestsRowCount() == 3)) &&
                _connectionSuggestions.isNotEmpty) {
              return SlideIn(
                key: _userCardKeys[index],
                delay: Duration(milliseconds: index * 50),
                child: UserCard(
                  user: PublicUserData(
                    name:
                        '${_connectionSuggestions.length} Connection Suggestion${_connectionSuggestions.length > 1 ? 's' : ''}',
                  ),
                  contextWidget: Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () => Navigator.pushNamed(
                    context,
                    SuggestionsScreen.id,
                    arguments: RequestsScreenArguments(
                      _refreshIndicatorKey.currentState.show,
                    ),
                  ),
                ),
              );
            }
            return SlideIn(
              key: _userCardKeys[index],
              delay: Duration(milliseconds: index * 50),
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
            delay: Duration(milliseconds: index * 50),
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

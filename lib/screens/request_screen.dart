import 'package:duochat/db.dart';
import 'package:duochat/models.dart';
import 'package:duochat/widget/top_nav_bar.dart';
import 'package:duochat/widget/user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:duochat/screens/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestsScreenArguments {
  final Function refresh;
  RequestsScreenArguments(this.refresh);
}

class IncomingRequestsScreen extends StatefulWidget {

  static String id = 'incoming_requests_screen';

  @override
  State<StatefulWidget> createState() => _IncomingRequestsScreenState();
}
class _IncomingRequestsScreenState extends State<IncomingRequestsScreen> {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<GlobalKey<SlideInState>> _userCardKeys = [];
  List<PublicUserData> _requests = [];
  Function refresh;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0), () {
      _refreshIndicatorKey.currentState.show();
    });
  }

  @override
  void dispose() {
    super.dispose();
    refresh();
  }

  Future<void> _updateRequests() async {

    _userCardKeys.forEach((key) => key.currentState.slideOut());

    User firebaseUser = Provider.of<User>(context, listen: false);
    PrivateUserData requestsData = await PrivateUserData.fromID(firebaseUser.uid);
    QuerySnapshot incomingRequestsSnapshot = await FirebaseFirestore.instance.collection("publicUserInfo")
        .where('id', whereIn: requestsData.incomingRequests.toList()+['']).get();

    if(_requests.length > 0) {
      await Future.delayed(Duration(milliseconds: 500));
    }
    setState(() { _requests = []; });
    await Future.delayed(Duration(milliseconds: 10));
    setState(() {
      _requests = incomingRequestsSnapshot.docs.map((doc) => PublicUserData.fromMap(doc.data())).toList();
      _userCardKeys = List<GlobalKey<SlideInState>>();
      for(int i = 0; i < _requests.length; i++) {
        _userCardKeys.add(GlobalKey<SlideInState>());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final RequestsScreenArguments args = ModalRoute.of(context).settings.arguments;
    refresh = args.refresh;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              TopNavBar(
                title: 'Incoming Requests',
                suffix: CupertinoButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.arrow_back,
                        size: 18.0,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _updateRequests,
                  child: ListView.builder(
                    itemCount: _requests.length,
                    itemBuilder: (BuildContext context, int index) => SlideIn(
                      key: _userCardKeys[index],
                      delay: Duration(milliseconds: index*50),
                      child: UserCard(
                        user: _requests[index],
                        message: _requests[index].username,
                        onTap: () => Navigator.pushNamed(
                          context,
                          ProfileScreen.id,
                          arguments: ProfileScreenArguments(
                            _requests[index],
                            _refreshIndicatorKey.currentState.show,
                          ),
                        ),
                        contextWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextButton(
                              child: Icon(Icons.check),
                              onPressed: () async {
                                await DatabaseService.acceptRequest(context, _requests[index].id);
                                _refreshIndicatorKey.currentState?.show();
                              },
                              style: TextButton.styleFrom(
                                minimumSize: Size.fromRadius(10),
                                shape: CircleBorder(),
                              ),
                            ),
                            OutlinedButton(
                              child: Icon(Icons.clear),
                              onPressed: () async {
                                await DatabaseService.rejectRequest(context, _requests[index].id);
                                _updateRequests();
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size.fromRadius(10),
                                shape: CircleBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class OutgoingRequestsScreen extends StatefulWidget {

  static String id = 'outgoing_requests_screen';

  @override
  State<StatefulWidget> createState() => _OutgoingRequestsScreenState();
}
class _OutgoingRequestsScreenState extends State<OutgoingRequestsScreen> {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<GlobalKey<SlideInState>> _userCardKeys = [];
  List<PublicUserData> _requests = [];
  Function refresh;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0), () {
      _refreshIndicatorKey.currentState.show();
    });
  }

  @override
  void dispose() {
    super.dispose();
    refresh();
  }

  Future<void> _updateRequests() async {

    _userCardKeys.forEach((key) => key.currentState.slideOut());

    User firebaseUser = Provider.of<User>(context, listen: false);
    PrivateUserData requestsData = await PrivateUserData.fromID(firebaseUser.uid);
    QuerySnapshot outgoingRequestsSnapshot = await FirebaseFirestore.instance.collection("publicUserInfo")
        .where('id', whereIn: requestsData.outgoingRequests.toList()+['']).get();

    if(_requests.length > 0) {
      await Future.delayed(Duration(milliseconds: 500));
    }
    setState(() { _requests = []; });
    await Future.delayed(Duration(milliseconds: 10));
    setState(() {
      _requests = outgoingRequestsSnapshot.docs.map((doc) => PublicUserData.fromMap(doc.data())).toList();
      _userCardKeys = List<GlobalKey<SlideInState>>();
      for(int i = 0; i < _requests.length; i++) {
        _userCardKeys.add(GlobalKey<SlideInState>());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final RequestsScreenArguments args = ModalRoute.of(context).settings.arguments;
    refresh = args.refresh;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              TopNavBar(
                title: 'Outgoing Requests',
                suffix: CupertinoButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.arrow_back,
                        size: 18.0,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child:  RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _updateRequests,
                  child: ListView.builder(
                    itemCount: _requests.length,
                    itemBuilder: (BuildContext context, int index) => SlideIn(
                      key: _userCardKeys[index],
                      delay: Duration(milliseconds: index*50),
                      child: UserCard(
                        user: _requests[index],
                        message: _requests[index].username,
                        onTap: () =>
                            Navigator.pushNamed(
                              context,
                              ProfileScreen.id,
                              arguments: ProfileScreenArguments(
                                _requests[index],
                                _refreshIndicatorKey.currentState.show,
                              ),
                            ),
                        contextWidget: OutlinedButton(
                          child: Icon(Icons.clear),
                          onPressed: () async {
                            await DatabaseService.cancelRequest(context, _requests[index].id);
                            _refreshIndicatorKey.currentState?.show();
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size.fromRadius(10),
                            shape: CircleBorder(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}



class SuggestionsScreen extends StatefulWidget {

  static String id = 'suggestions_screen';

  @override
  State<StatefulWidget> createState() => _SuggestionsScreenState();
}
class _SuggestionsScreenState extends State<SuggestionsScreen> {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<GlobalKey<SlideInState>> _userCardKeys = [];
  List<PublicUserData> _suggestions = [];
  Function refresh;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0), () {
      _refreshIndicatorKey.currentState.show();
    });
  }

  @override
  void dispose() {
    super.dispose();
    refresh();
  }

  Future<void> _updateSuggestions() async {

    _userCardKeys.forEach((key) => key.currentState.slideOut());
    
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("publicUserInfo").get();
    final users = snapshot.docs.map((doc) => PublicUserData.fromMap(doc.data())).toList();
    
    User firebaseUser = Provider.of<User>(context, listen: false);
    final requestsData = await PrivateUserData.fromID(firebaseUser.uid);
    final interestsData = await PublicUserData.fromID(firebaseUser.uid);

    if(_suggestions.length > 0) {
      await Future.delayed(Duration(milliseconds: 500));
    }

    setState(() { _suggestions = []; });
    await Future.delayed(Duration(milliseconds: 10));

    setState(() {
      users.forEach((user) {
        if(user.id == firebaseUser.uid) return;
        if(requestsData.incomingRequests.contains(user.id)
          || requestsData.outgoingRequests.contains(user.id)
          || interestsData.connections.contains(user.id)) return;
        final interests = interestsData.interests.toLowerCase().split(new RegExp("[,. /\n]+"));
        for(var interest in user.interests.toLowerCase().split(new RegExp("[,. /\n]+"))) {
          if(interests.contains(interest)) {
            _suggestions.add(user);
            break;
          }
        }
      });
      _userCardKeys = List<GlobalKey<SlideInState>>();
      for(int i = 0; i < _suggestions.length; i++) {
        _userCardKeys.add(GlobalKey<SlideInState>());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final RequestsScreenArguments args = ModalRoute.of(context).settings.arguments;
    refresh = args.refresh;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              TopNavBar(
                title: 'Suggestions',
                suffix: CupertinoButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.arrow_back,
                        size: 18.0,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child:  RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _updateSuggestions,
                  child: ListView.builder(
                    itemCount: _suggestions.length,
                    itemBuilder: (BuildContext context, int index) => SlideIn(
                      key: _userCardKeys[index],
                      delay: Duration(milliseconds: index*50),
                      child: UserCard(
                        user: _suggestions[index],
                        message: _suggestions[index].username,
                        onTap: () =>
                            Navigator.pushNamed(
                              context,
                              ProfileScreen.id,
                              arguments: ProfileScreenArguments(
                                _suggestions[index],
                                _refreshIndicatorKey.currentState.show,
                              ),
                            ),
                        contextWidget: OutlinedButton(
                          child: Icon(Icons.add),
                          onPressed: () async {
                            await DatabaseService.requestConnection(context, _suggestions[index].id);
                            _refreshIndicatorKey.currentState?.show();
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size.fromRadius(10),
                            shape: CircleBorder(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
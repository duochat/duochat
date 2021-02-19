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
  final Function onRefresh;

  RequestsScreenArguments({this.onRefresh});
}

class IncomingRequestsScreen extends StatefulWidget {
  static String id = 'incoming_requests_screen';
  @override
  State<StatefulWidget> createState() => _IncomingRequestsScreenState();
}
class _IncomingRequestsScreenState extends State<IncomingRequestsScreen> {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<PublicUserData> _requests = [];
  Function onRefresh;
  
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1000), () {
      _refreshIndicatorKey.currentState?.show();
    });
  }
  
  @override
  void dispose() {
    if(onRefresh != null) onRefresh();
    super.dispose();
  }

  Future<void> _updateRequests() async {
    User firebaseUser = Provider.of<User>(context, listen: false);
    if(firebaseUser == null) {
      Future.delayed(Duration(milliseconds: 1000), () {
        _refreshIndicatorKey.currentState?.show();
      });
    }
    PrivateUserData requestsData = await PrivateUserData.fromID(firebaseUser.uid);
    QuerySnapshot incomingRequestsSnapshot = await FirebaseFirestore.instance.collection("publicUserInfo")
        .where('id', whereIn: requestsData.incomingRequests.toList()+['']).get();
    setState(() {
      _requests = incomingRequestsSnapshot.docs.map((doc) => PublicUserData.fromMap(doc.data())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final RequestsScreenArguments args = ModalRoute.of(context).settings.arguments;
    onRefresh = args.onRefresh;
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
                    itemBuilder: (BuildContext context, int index) {
                      return UserCard(
                        user: _requests[index],
                        message: _requests[index].username,
                        onTap: () => Navigator.pushNamed(
                          context,
                          ProfileScreen.id,
                          arguments: ProfileScreenArguments(
                            user: _requests[index],
                            onRefresh: _updateRequests,
                          ),
                        ),
                        contextWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextButton(
                              child: Icon(Icons.check),
                              onPressed: () async {
                                await DatabaseService.acceptRequest(context, _requests[index].id);
                                _updateRequests();
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
                      );
                    },
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
  List<PublicUserData> _requests = [];
  Function onRefresh;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1000), () {
      _refreshIndicatorKey.currentState?.show();
    });
  }

  @override
  void dispose() {
    if(onRefresh != null) onRefresh();
    super.dispose();
  }

  Future<void> _updateRequests() async {
    User firebaseUser = Provider.of<User>(context, listen: false);
    if(firebaseUser == null) {
      Future.delayed(Duration(milliseconds: 1000), () {
        _refreshIndicatorKey.currentState?.show();
      });
    }
    PrivateUserData requestsData = await PrivateUserData.fromID(firebaseUser.uid);
    QuerySnapshot outgoingRequestsSnapshot = await FirebaseFirestore.instance.collection("publicUserInfo")
        .where('id', whereIn: requestsData.outgoingRequests.toList()+['']).get();
    setState(() {
      _requests = outgoingRequestsSnapshot.docs.map((doc) => PublicUserData.fromMap(doc.data())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final RequestsScreenArguments args = ModalRoute.of(context).settings.arguments;
    onRefresh = args.onRefresh;
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
                child: RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _updateRequests,
                  child: ListView.builder(
                    itemCount: _requests.length,
                    itemBuilder: (BuildContext context, int index) {
                      return UserCard(
                        user: _requests[index],
                        message: _requests[index].username,
                        onTap: () =>
                            Navigator.pushNamed(
                              context,
                              ProfileScreen.id,
                              arguments: ProfileScreenArguments(
                                user: _requests[index],
                                onRefresh: _updateRequests,
                              ),
                            ),
                        contextWidget: OutlinedButton(
                          child: Icon(Icons.clear),
                          onPressed: () async {
                            await DatabaseService.cancelRequest(context, _requests[index].id);
                            _updateRequests();
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size.fromRadius(10),
                            shape: CircleBorder(),
                          ),
                        ),
                      );
                    },
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
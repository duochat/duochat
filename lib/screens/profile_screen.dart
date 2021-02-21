import 'package:duochat/db.dart';
import 'package:duochat/widget/top_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:duochat/models.dart';

class ProfileScreenArguments {
  final PublicUserData user;
  final Function refresh;

  ProfileScreenArguments(this.user, this.refresh);
}

class ProfileScreen extends StatefulWidget {

  static String id = 'profile_screen';

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  PublicUserData user;
  Function refresh;

  bool sendingRequest = false;
  int connectionState = 0; // 1: not connected, 2: outgoing request, 3: incoming request, 4: connected
  bool changedState = false;

  @override
  void initState() {
    super.initState();
    updateConnection();
  }

  @override
  void dispose() {
    super.dispose();
    if(changedState) refresh();
  }

  Future<void> updateConnection() async {
    final myID = FirebaseAuth.instance.currentUser.uid;
    PublicUserData connectionsData = await PublicUserData.fromID(myID);
    PrivateUserData requestsData = await PrivateUserData.fromID(myID);

    setState(() {
      if(connectionsData.connections.contains(user.id)) {
        connectionState = 4;
      } else if(requestsData.incomingRequests.contains(user.id)) {
        connectionState = 3;
      } else if(requestsData.outgoingRequests.contains(user.id)) {
        connectionState = 2;
      } else {
        connectionState = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProfileScreenArguments args = ModalRoute.of(context).settings.arguments;
    user = args.user;
    refresh = args.refresh;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              TopNavBar(
                title: user.name,
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
                child: FutureBuilder(
                  future: updateConnection(),
                  builder: (context, snapshot) => SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Container(
                              child: CircleAvatar(
                                radius: 100.0,
                                backgroundImage: NetworkImage(user.photoURL),
                              ),
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8.0,
                                )
                              ],
                            ),
                          )
                          ),
                          SizedBox(height: 12.0),
                          Center(
                            child: TextButton(
                              child: Text(
                                connectionState == 1 ? 'Request Connection' :
                                connectionState == 2 ? 'Cancel Request' :
                                connectionState == 3 ? 'Accept Request' :
                                connectionState == 4 ? 'Remove Connection' :
                                'Loading...'
                              ),
                              onPressed: connectionState == 0 ? null : () async {
                                setState(() { sendingRequest = true; });
                                if(connectionState == 1) {
                                  await DatabaseService.requestConnection(context, user.id);
                                } else if(connectionState == 2) {
                                  await DatabaseService.cancelRequest(context, user.id);
                                } else if(connectionState == 3) {
                                  await DatabaseService.acceptRequest(context, user.id);
                                } else if(connectionState == 4) {
                                  await DatabaseService.removeConnection(context, user.id);
                                }
                                await updateConnection();
                                changedState = true;
                                setState(() { sendingRequest = false; });
                              },
                              style: TextButton.styleFrom(
                                minimumSize: Size.fromRadius(20),
                              ),
                            ),
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            "User Bio",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Text(
                            user.bio,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            "Career Interests",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Text(
                            user.interests,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black87,
                            ),
                          ),
                        ],
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
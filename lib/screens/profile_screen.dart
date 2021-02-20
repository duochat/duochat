import 'package:duochat/db.dart';
import 'package:duochat/widget/top_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:duochat/models.dart';
import 'package:provider/provider.dart';

class ProfileScreenArguments {
  final PublicUserData user;
  final Function onRefresh;

  ProfileScreenArguments({this.user, this.onRefresh});
}

class ProfileScreen extends StatefulWidget {
  static String id = 'profile_screen';

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  PublicUserData user;
  Function onRefresh;
  bool sendingRequest = false;
  int connectionState = 0; // 1: not connected, 2: outgoing request, 3: incoming request, 4: connected

  @override
  void initState() {
    super.initState();
    updateConnection();
  }

  Future<void> updateConnection() async {
    User firebaseUser = Provider.of<User>(context, listen: false);
    PublicUserData connectionsData = await PublicUserData.fromID(firebaseUser.uid);
    PrivateUserData requestsData = await PrivateUserData.fromID(firebaseUser.uid);

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
    onRefresh = args.onRefresh;

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
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 100.0,
                          backgroundImage: NetworkImage(user.photoURL),
                        ),
                        SizedBox(height: 8.0),
                        TextButton(
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
                            setState(() { sendingRequest = false; });
                          },
                          style: TextButton.styleFrom(
                            minimumSize: Size.fromRadius(20),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          user.bio ?? "This person doesn't have a bio yet.",
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
            ],
          ),
        ),
      ),
    );
  }

}
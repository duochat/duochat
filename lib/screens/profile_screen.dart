import 'package:duochat/widget/top_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:duochat/models.dart';
import 'package:provider/provider.dart';

class ProfileScreenArguments {
  final PublicUserData user;

  ProfileScreenArguments(this.user);
}

class ProfileScreen extends StatefulWidget {
  static String id = 'profile_screen';

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  PublicUserData user;
  bool sendingRequest = false;
  int connectionState = 0; // 0: not connected, 1: outgoing request, 2: incoming request, 3: connected

  void initState() {
    super.initState();
    checkConnection();
  }

  void checkConnection() async {
    User firebaseUser = Provider.of<User>(context, listen: false);
    print('got id');
    PublicUserData connectionsData = await PublicUserData.fromID(firebaseUser.uid);
    PrivateUserData requestsData = await PrivateUserData.fromID(firebaseUser.uid);

    setState(() {
      if(connectionsData.connections.contains(user.id)) {
        connectionState = 3;
      } else if(requestsData.incomingRequests.contains(user.id)) {
        connectionState = 2;
      } else if(requestsData.outgoingRequests.contains(user.id)) {
        connectionState = 1;
      } else {
        connectionState = 0;
      }
    });
  }

  void requestConnection() async {

    setState(() { sendingRequest = true; });

    User firebaseUser = Provider.of<User>(context, listen: false);
    PrivateUserData sender = await PrivateUserData.fromID(firebaseUser.uid);
    PrivateUserData receiver = await PrivateUserData.fromID(user.id);
    sender.outgoingRequests.add(user.id);
    receiver.incomingRequests.add(firebaseUser.uid);
    await sender.writeToDB();
    await receiver.writeToDB();

    setState(() { sendingRequest = false; });
    checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    final ProfileScreenArguments args = ModalRoute.of(context).settings.arguments;
    user = args.user;

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
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 100.0,
                        backgroundImage: NetworkImage(user.photoURL),
                      ),
                      SizedBox(height: 8.0),
                      TextButton(
                        child: Text(
                          connectionState == 0 ? 'Request Connection' :
                          connectionState == 1 ? 'Request Sent' :
                          connectionState == 2 ? 'Accept Request' :
                          'Connected'
                        ),
                        onPressed:
                          connectionState == 0 ? requestConnection :
                          connectionState == 1 || connectionState == 3 ? null :
                          () => print("accepted connection request from ${user.name}"),
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
            ],
          ),
        ),
      ),
    );
  }

}
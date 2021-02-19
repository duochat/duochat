import 'package:duochat/widget/top_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:duochat/models.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  void requestConnection() async {
    User firebaseUser = Provider.of<User>(context, listen: false);
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('publicUserInfo')
        .doc(firebaseUser.uid).get();

    print('send connection request with ${user.name} from ${snapshot.get('name')}');
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
                        child: Text("Request Connection"),
                        onPressed: requestConnection,
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
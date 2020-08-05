import 'package:duochat/db.dart';
import 'package:duochat/screens/edit_profile_screen.dart';
import 'package:duochat/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    FirebaseUser firebaseUser = Provider.of<FirebaseUser>(context);

    if (firebaseUser == null) {
      return Container();
    }

    return StreamBuilder<UserData>(
      stream: db.streamUserData(firebaseUser.uid),
      builder: (context, snapshot) {
        UserData data = snapshot.data;
        if (data == null) return Container();

        return Scaffold(
          body: Container(
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: NetworkImage(data.photoURL),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        data.name,
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        '@' + data.username,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black45,
                        ),
                      ),
                      FlatButton(
                        onPressed: () async {
                          FirebaseAuth.instance.signOut();
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.id);
                        },
                        child: Text('Logout'),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(30.0),
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Color(0xFFe3f4ff),
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                      ),
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.6),
                        spreadRadius: 1,
                        blurRadius: 1,
                      )
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, EditProfileScreen.id);
                    },
                    child: Center(
                      child: Text(
                        'EDIT PROFILE',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

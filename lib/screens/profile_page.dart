import 'package:duochat/db.dart';
import 'package:duochat/screens/login_screen.dart';
import 'package:duochat/widget/top_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    User firebaseUser = Provider.of<User>(context);

    if (firebaseUser == null) {
      return Container();
    }

    return StreamBuilder<PublicUserData>(
      stream: db.streamPublicUserData(firebaseUser.uid),
      builder: (context, snapshot) {
        PublicUserData data = snapshot.data;
        if (data == null) return Container();

        return Scaffold(
          body: SafeArea(
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  TopNavBar(
                    image: NetworkImage(data.photoURL),
                    title: 'Profile',
                    suffix: CupertinoButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacementNamed(context, LoginScreen.id);
                      },
                      child: Text(
                        'Logout',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            QrImage(
                              data: data.username,
                              version: QrVersions.auto,
                              errorCorrectionLevel: QrErrorCorrectLevel.H,
                              size: 200,
                              gapless: true,
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  padding: EdgeInsets.all(3.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircleAvatar(
                                    radius: 28.0,
                                    backgroundImage:
                                        NetworkImage(data.photoURL),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          data.name,
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'heyo wuts popping bio blah blah blah',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black87,
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
//                  FloatingBottomButton(
//                    onTap: () {
//                      Navigator.pushNamed(context, EditProfileScreen.id);
//                    },
//                    text: 'EDIT PROFILE',
//                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:duochat/db.dart';
import 'package:duochat/screens/login_screen.dart';
import 'package:duochat/widget/floating_bottom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models.dart';
import 'edit_profile_screen.dart';

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

    return StreamBuilder<PublicUserData>(
      stream: db.streamPublicUserData(firebaseUser.uid),
      builder: (context, snapshot) {
        PublicUserData data = snapshot.data;
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
                              child: CircleAvatar(
                                radius: 30.0,
                                backgroundImage: NetworkImage(data.photoURL),
                              ),
                            ),
                          )
                        ],
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
                FloatingBottomButton(
                  onTap: () {
                    Navigator.pushNamed(context, EditProfileScreen.id);
                  },
                  text: 'EDIT PROFILE',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

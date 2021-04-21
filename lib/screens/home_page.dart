import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duochat/models.dart';
import 'package:duochat/screens/support_screen.dart';
import 'package:duochat/widget/chat_list.dart';
import 'package:duochat/widget/loading.dart';
import 'package:duochat/widget/top_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    PublicUserData userData = Provider.of<PublicUserData>(context);

    if (userData == null) {
      return Container();
    }

    return Scaffold(
      backgroundColor: Color(0xffFCF4E6),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TopNavBar(
              image: AssetImage('graphics/logo.png'),
              hasImageBorder: false,
              title: 'DuoChat',
              suffix: CupertinoButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    SupportScreen.id,
                  );
                },
                child: Text(
                  'Support',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ),
            StreamBuilder<List<PublicUserData>>(
                stream: FirebaseFirestore.instance
                    .collection('publicUserInfo')
                    .where('id', whereIn: userData.connections.toList() + [''])
                    .snapshots()
                    .map((snap) => snap.docs
                        .map((doc) => PublicUserData.fromMap(doc.data()))
                        .toList()),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Loading();
                  return ChatList(
                      chats: snapshot.data.map((PublicUserData user) {
                    List<String> ids = [
                      FirebaseAuth.instance.currentUser.uid,
                      user.id
                    ];
                    ids.sort();
                    return Chat(
                      name: user.name,
                      id: ids.join('-'),
                      photoURL: user.photoURL,
                    );
                  }).toList());
                }),
          ],
        ),
      ),
    );
  }
}

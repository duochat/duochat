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
  List<PublicUserData> _connections = [];

  void initState() {
    super.initState();
    _updateConnections();
  }

  Future<void> _updateConnections() async {
    User firebaseUser = Provider.of<User>(context, listen: false);
    PublicUserData connectionsData =
        await PublicUserData.fromID(firebaseUser.uid);
    QuerySnapshot connectionsSnapshot = await FirebaseFirestore.instance
        .collection("publicUserInfo")
        .where('id', whereIn: connectionsData.connections.toList() + [''])
        .get();
    setState(() {
      _connections = connectionsSnapshot.docs
          .map((doc) => PublicUserData.fromMap(doc.data()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TopNavBar(
              image: NetworkImage('https://picsum.photos/200/200'),
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
            StreamBuilder<PublicUserData>(
                stream: FirebaseFirestore.instance
                    .collection('publicUserInfo')
                    .doc(FirebaseAuth.instance.currentUser.uid)
                    .snapshots()
                    .map((event) => PublicUserData.fromMap(event.data())),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Loading();
                  return StreamBuilder<List<PublicUserData>>(
                      stream: FirebaseFirestore.instance
                          .collection('publicUserInfo')
                          .where('id',
                              whereIn:
                                  snapshot.data.connections.toList() + [''])
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
                            messages: <ChatMessage>[],
                          );
                        }).toList());
                      });
                }),
          ],
        ),
      ),
    );
  }
}

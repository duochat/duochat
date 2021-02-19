import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duochat/screens/home_screen_container.dart';
import 'package:duochat/widget/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        setState(() {
          isLoading = true;
        });
        _handleFirebaseUser(user);
      }
    } catch (e) {
      print(e);
    }
  }

  void _handleFirebaseUser(User user) async {
    // Check is already sign up
    final DocumentSnapshot result = await FirebaseFirestore.instance
        .collection('privateUserInfo')
        .doc(user.uid)
        .get();
    if (!result.exists) {
      // Update data to server if new user
      FirebaseFirestore.instance
          .collection('publicUserInfo')
          .doc(user.uid)
          .set({
        'name': user.displayName,
        'username': user.displayName,
        'photoURL': user.photoURL,
        'id': user.uid,
      });
      FirebaseFirestore.instance
          .collection('privateUserInfo')
          .doc(user.uid)
          .set({
        'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        'finishedOnboarding': false,
      });

      this.setState(() {
        isLoading = false;
      });

      Navigator.pushReplacementNamed(context, HomeScreenContainer.id);
//      Navigator.pushReplacementNamed(context, OnboardingScreen.id);
    } else {
      this.setState(() {
        isLoading = false;
      });

      if (result.data()['finishedOnboarding']) {
        Navigator.pushReplacementNamed(context, HomeScreenContainer.id);
      } else {
        Navigator.pushReplacementNamed(context, HomeScreenContainer.id);
//        Navigator.pushReplacementNamed(context, OnboardingScreen.id);
      }
    }
  }

  Future<Null> handleSignInWithGoogle(BuildContext context) async {
    this.setState(() {
      isLoading = true;
    });

    try {
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      User firebaseUser = (await _auth.signInWithCredential(credential)).user;

      if (firebaseUser != null) {
        _handleFirebaseUser(firebaseUser);
      } else {
        _handleSignInFail(context, 'Google');
      }
    } catch (e, s) {
      print('$e $s');
      _handleSignInFail(context, 'Google');
    }
  }

  void _handleSignInFail(BuildContext context, String provider) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Sign in with $provider failed'),
      ),
    );
    this.setState(() {
      isLoading = false;
    });
  }

  void handleSignInWithFacebook(BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Facebook not implemented yet'),
      ),
    );
  }

  void handleSignInWithApple(BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Apple not implemented yet'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(
        builder: (context) => Stack(
          children: <Widget>[
            SafeArea(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 24.0),
                    SignInButton(
                      Buttons.Google,
                      onPressed: () => handleSignInWithGoogle(context),
                    ),
                    SizedBox(height: 8.0),
                    SignInButton(
                      Buttons.Facebook,
                      onPressed: () => handleSignInWithFacebook(context),
                    ),
                    if (Platform.isIOS) ...[
                      SizedBox(height: 8.0),
                      SignInButton(
                        Buttons.Apple,
                        onPressed: () => handleSignInWithApple(context),
                      ),
                    ]
                  ],
                ),
              ),
            ),

            // Loading
            Positioned(
              child: isLoading ? const Loading() : Container(),
            ),
          ],
        ),
      ),
    );
  }
}

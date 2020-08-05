import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duochat/screens/home_screen_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  static String id = 'onboarding_screen';

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _auth = FirebaseAuth.instance;

  String messageText;

  final _firestore = Firestore.instance;
  FirebaseUser firebaseUser;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        firebaseUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void handleFinishedOnboarding() {
    Firestore.instance
        .collection('users')
        .document(firebaseUser.uid)
        .updateData({
      'finishedOnboarding': true,
    });
    Navigator.pushReplacementNamed(context, HomeScreenContainer.id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: RaisedButton(
          onPressed: handleFinishedOnboarding,
          child: Text('Finish Onboarding'),
        ),
      ),
    );
  }
}

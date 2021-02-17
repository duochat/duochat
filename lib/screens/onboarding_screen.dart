import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duochat/screens/home_screen_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  static String id = 'onboarding_screen';

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  void handleFinishedOnboarding(BuildContext context) {
    User user = Provider.of<User>(context, listen: false);
    FirebaseFirestore.instance
        .collection('privateUserInfo')
        .doc(user.uid)
        .update({
      'finishedOnboarding': true,
    });
    FirebaseFirestore.instance
        .collection('publicUserInfo')
        .doc(user.uid)
        .update({
      'username': user.uid,
    });
    Navigator.pushReplacementNamed(context, HomeScreenContainer.id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: RaisedButton(
          onPressed: () => handleFinishedOnboarding(context),
          child: Text('Finish Onboarding'),
        ),
      ),
    );
  }
}

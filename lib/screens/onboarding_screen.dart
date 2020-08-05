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
    FirebaseUser user = Provider.of<FirebaseUser>(context, listen: false);
    Firestore.instance.collection('users').document(user.uid).updateData({
      'finishedOnboarding': true,
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

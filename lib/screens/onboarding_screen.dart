import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  static String id = 'onboarding_screen';

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text('Onboarding Screen'));
  }
}

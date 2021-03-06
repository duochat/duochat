import 'package:duochat/screens/answer_prompt_screen.dart';
import 'package:duochat/screens/chat_screen.dart';
import 'package:duochat/screens/edit_profile_screen.dart';
import 'package:duochat/screens/home_screen_container.dart';
import 'package:duochat/screens/login_screen.dart';
import 'package:duochat/screens/onboarding_screen.dart';
import 'package:duochat/screens/profile_screen.dart';
import 'package:duochat/screens/scan_qr_screen.dart';
import 'package:duochat/screens/support_screen.dart';
import 'package:duochat/widget/loading.dart';
import 'package:duochat/screens/request_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:duochat/push_notifications.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   Future<FirebaseApp> _initialization;

  MyApp () {
    _initialization  = Firebase.initializeApp();
    _initialization.whenComplete (() {
      PushNotificationsManager().init();
    });
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          throw "Something went wrong";
        }
        if (snapshot.connectionState != ConnectionState.done) {
          return Loading();
        }
        return MultiProvider(
          providers: [
            StreamProvider<User>.value(
              value: FirebaseAuth.instance.authStateChanges(),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
//          primarySwatch: MaterialColor(0xFFFF7A00),
              backgroundColor: Colors.white,
              canvasColor: Colors.white,
              primaryColor: Color(0xFFFF7A00),
              textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.orange,
                padding: EdgeInsets.all(10),
                shape: StadiumBorder(),
              )),
              outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(
                primary: Colors.orange,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.orange),
                padding: EdgeInsets.all(10),
                shape: StadiumBorder(),
              ),),
              // This makes the visual density adapt to the platform that you run
              // the app on. For desktop platforms, the controls will be smaller and
              // closer together (more dense) than on mobile platforms.
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            initialRoute: LoginScreen.id,
            routes: {
              LoginScreen.id: (context) => LoginScreen(),
              OnboardingScreen.id: (context) => OnboardingScreen(),
              HomeScreenContainer.id: (context) => HomeScreenContainer(),
              EditProfileScreen.id: (context) => EditProfileScreen(),
              ChatScreen.id: (context) => ChatScreen(),
              ScanQrScreen.id: (context) => ScanQrScreen(),
              AnswerPromptScreen.id: (context) => AnswerPromptScreen(),
              SupportScreen.id: (context) => SupportScreen(),
              ProfileScreen.id: (context) => ProfileScreen(),
              IncomingRequestsScreen.id: (context) => IncomingRequestsScreen(),
              OutgoingRequestsScreen.id: (context) => OutgoingRequestsScreen(),
              SuggestionsScreen.id: (context) => SuggestionsScreen(),
            },
          ),
        );
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duochat/models.dart';
import "package:duochat/push_notifications.dart";
import 'package:duochat/screens/chat/chat_flow.dart';
import 'package:duochat/screens/edit_profile_screen.dart';
import 'package:duochat/screens/home_screen_container.dart';
import 'package:duochat/screens/login_screen.dart';
import 'package:duochat/screens/onboarding_screen.dart';
import 'package:duochat/screens/profile_screen.dart';
import 'package:duochat/screens/request_screen.dart';
import 'package:duochat/screens/scan_qr_screen.dart';
import 'package:duochat/screens/support_screen.dart';
import 'package:duochat/widget/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream_transform/stream_transform.dart';

const chatRoutePrefix = "/chat/";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<FirebaseApp> _initialization;

  MyApp() {
    _initialization = Firebase.initializeApp();
    _initialization.whenComplete(() {
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
            StreamProvider<PublicUserData>.value(
              value: FirebaseAuth.instance.authStateChanges().switchMap(
                  (event) => FirebaseFirestore.instance
                      .collection('publicUserInfo')
                      .doc(event.uid)
                      .snapshots()
                      .map((event) => PublicUserData.fromMap(event.data()))),
              initialData: null,
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
              textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.orange,
                padding: EdgeInsets.all(10),
                shape: StadiumBorder(),
              )),
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                  primary: Colors.orange,
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.orange),
                  padding: EdgeInsets.all(10),
                  shape: StadiumBorder(),
                ),
              ),
              // This makes the visual density adapt to the platform that you run
              // the app on. For desktop platforms, the controls will be smaller and
              // closer together (more dense) than on mobile platforms.
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            initialRoute: LoginScreen.id,
            onGenerateRoute: (settings) {
              Widget page;
              if (settings.name == LoginScreen.id) {
                page = LoginScreen();
              } else if (settings.name == OnboardingScreen.id) {
                page = OnboardingScreen();
              } else if (settings.name == HomeScreenContainer.id) {
                page = HomeScreenContainer();
              } else if (settings.name.startsWith(chatRoutePrefix)) {
                final subRoute =
                    settings.name.substring(chatRoutePrefix.length);
                page = ChatFlow(chatRoute: subRoute);
              } else if (settings.name == EditProfileScreen.id) {
                page = EditProfileScreen();
              } else if (settings.name == ScanQrScreen.id) {
                page = ScanQrScreen();
              } else if (settings.name == SupportScreen.id) {
                page = SupportScreen();
              } else if (settings.name == ProfileScreen.id) {
                page = ProfileScreen();
              } else if (settings.name == IncomingRequestsScreen.id) {
                page = IncomingRequestsScreen();
              } else if (settings.name == OutgoingRequestsScreen.id) {
                page = OutgoingRequestsScreen();
              } else if (settings.name == SuggestionsScreen.id) {
                page = SuggestionsScreen();
              } else {
                throw Exception("Unknown route: ${settings.name}");
              }
              return MaterialPageRoute(
                builder: (context) {
                  return page;
                },
                settings: settings,
              );
            },
          ),
        );
      },
    );
  }
}

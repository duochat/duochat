import 'package:duochat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatFlow extends StatefulWidget {
  const ChatFlow({
    Key key,
    this.chatRoute,
  }) : super(key: key);

  final String chatRoute;

  @override
  ChatFlowState createState() => ChatFlowState();
}

class ChatFlowState extends State<ChatFlow> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      initialRoute: widget.chatRoute,
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route _onGenerateRoute(RouteSettings settings) {
    final ChatScreenArguments args = ModalRoute.of(context).settings.arguments;

    Widget page;
    switch (settings.name) {
      case ChatScreen.id:
        page = ChatScreen();
        break;
    }

    print(settings.name);

    return MaterialPageRoute<dynamic>(
      builder: (context) {
        return MultiProvider(
          providers: [Provider(create: (_) => args.chat)],
          child: page,
        );
      },
      settings: settings,
    );
  }
}

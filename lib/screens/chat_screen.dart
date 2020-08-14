import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreenArguments {
  final String chatID;

  ChatScreenArguments(this.chatID);
}

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final ChatScreenArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            ChatTopNav(),
            Text(args.chatID),
            Flexible(
              child: Container(),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CupertinoTextField(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                placeholder: "Message here...",
                decoration: BoxDecoration(
                  color: Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.all(
                    Radius.circular(100.0),
                  ),
                  border: Border.all(color: Color(0xFFE8E8E8)),
                ),
                suffix: Padding(
                  padding: EdgeInsets.only(right: 6.0),
                  child: CupertinoButton(
                    child: Icon(Icons.arrow_upward),
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                    onPressed: () {
                      print('Send');
                    },
                    padding: EdgeInsets.all(0.0),
                    minSize: 34.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatTopNav extends StatelessWidget {
  const ChatTopNav({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(16.0),
          child: Container(
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://picsum.photos/200/200'),
            ),
            width: 48.0,
            height: 48.0,
            padding: EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8.0,
              )
            ],
          ),
        ),
        Text(
          'Ian Chen',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Flexible(
          child: Container(),
        ),
        CupertinoButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Row(
            children: <Widget>[
              Icon(
                Icons.arrow_back,
                size: 18.0,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                width: 4.0,
              ),
              Text(
                'Back',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
            ],
          ),
        )
      ],
    );
  }
}

import 'package:duochat/widget/chat_messages.dart';
import 'package:duochat/widget/top_nav_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models.dart';

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
  final FocusNode myFocusNode = FocusNode();
  final myController = TextEditingController();
  bool loading = true;

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
    myController.dispose();

    super.dispose();
  }

  void handleChatMessageSubmit(String chatId) {
    print("send " + myController.text);

    ChatMessage message = ChatMessage(
      sender: ChatMessageSender(
        name: "Ian Chen",
        id: "dfas",
        photoURL:
            'https://static.toiimg.com/thumb/msid-67586673,width-800,height-600,resizemode-75,imgsize-3918697,pt-32,y_pad-40/67586673.jpg',
        isUser: true,
      ),
      text: myController.text,
      timestamp: DateTime.now(),
      readBy: [ChatMessageReadByUser(name: "dfas", id: "sadf")],
    );
    FirebaseDatabase.instance
        .reference()
        .child('chats')
        .child(chatId)
        .child("messages")
        .push()
        .set(message.toMap());

    myController.clear();
    myFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final ChatScreenArguments args = ModalRoute.of(context).settings.arguments;
    final chatId = args.chatID;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TopNavBar(
              image: NetworkImage('https://picsum.photos/200'),
              title: 'Ian Chen',
              suffix: CupertinoButton(
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
                  ],
                ),
              ),
            ),
            Flexible(
              child: StreamBuilder<Object>(
                stream: FirebaseDatabase.instance
                    .reference()
                    .child('chats')
                    .child(chatId)
                    .child("messages")
                    .onValue,
                builder: (context, snapshot) {
                  print(snapshot.data);
                  return ChatMessages(messages: []);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CupertinoTextField(
                controller: myController,
                focusNode: myFocusNode,
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                placeholder: "Message here...",
                decoration: BoxDecoration(
                  color: Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.all(
                    Radius.circular(100.0),
                  ),
                  border: Border.all(color: Color(0xFFE8E8E8)),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (result) {
                  handleChatMessageSubmit(chatId);
                },
                suffix: Padding(
                  padding: EdgeInsets.only(right: 6.0),
                  child: CupertinoButton(
                    child: Icon(Icons.arrow_upward),
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                    onPressed: () {
                      handleChatMessageSubmit(chatId);
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

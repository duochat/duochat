import 'package:duochat/widget/chat_messages.dart';
import 'package:duochat/widget/top_nav_bar.dart';
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

  final List<ChatMessage> chatMessages = <ChatMessage>[
    ChatMessage(
      sender: ChatMessageSender(
        name: "Ian Chen",
        photoURL:
            'https://scontent-sjc3-1.xx.fbcdn.net/v/t1.0-1/p100x100/107569367_699524004113639_5166376271392046689_o.jpg?_nc_cat=102&_nc_sid=dbb9e7&_nc_ohc=Kem28j5_aiAAX91MwvD&_nc_ht=scontent-sjc3-1.xx&_nc_tp=6&oh=e8af1536be6e3299f2f20e897b4e5069&oe=5F52B67C',
        isUser: false,
      ),
      text: "Ian Chen invited you to chat!",
      timestamp: DateTime(2021, 1, 7, 17, 45),
      readBy: [
        ChatMessageReadByUser(name: 'Nathan Wang', id: 'asdf'),
      ],
    ),
  ];

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
    myController.dispose();

    super.dispose();
  }

  void handleChatMessageSubmit() {
    setState(() {
      chatMessages.add(ChatMessage(
        sender: ChatMessageSender(
          name: "Ian Chen",
          photoURL:
              'https://scontent-sjc3-1.xx.fbcdn.net/v/t1.0-1/p100x100/107569367_699524004113639_5166376271392046689_o.jpg?_nc_cat=102&_nc_sid=dbb9e7&_nc_ohc=Kem28j5_aiAAX91MwvD&_nc_ht=scontent-sjc3-1.xx&_nc_tp=6&oh=e8af1536be6e3299f2f20e897b4e5069&oe=5F52B67C',
          isUser: true,
        ),
        text: myController.text,
        timestamp: DateTime.now(),
        readBy: [],
      ));
    });

    myController.clear();
    myFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final ChatScreenArguments args = ModalRoute.of(context).settings.arguments;

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
              child: ChatMessages(
                messages: chatMessages,
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
                  handleChatMessageSubmit();
                },
                suffix: Padding(
                  padding: EdgeInsets.only(right: 6.0),
                  child: CupertinoButton(
                    child: Icon(Icons.arrow_upward),
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                    onPressed: handleChatMessageSubmit,
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

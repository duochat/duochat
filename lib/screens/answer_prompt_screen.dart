import 'package:duochat/models.dart';
import 'package:duochat/widget/top_nav_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnswerPromptScreenArguments {
  final ChatMessage message;
  final Chat chat;

  AnswerPromptScreenArguments(this.message, this.chat);
}

class AnswerPromptScreen extends StatefulWidget {
  static String id = 'answer_prompt_screen';

  @override
  _AnswerPromptScreenState createState() => _AnswerPromptScreenState();
}

class _AnswerPromptScreenState extends State<AnswerPromptScreen> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AnswerPromptScreenArguments args =
        ModalRoute.of(context).settings.arguments;

    Chat chat = args.chat;
    ConversationPrompt prompt = args.message.conversationPrompt;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TopNavBar(
              image: NetworkImage(chat.photoURL),
              title: chat.name,
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
                      'Skip',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                color: Theme.of(context).primaryColor,
              ),
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
              child: Column(
                children: <Widget>[
                  Text(
                    prompt.prompt,
                    style: TextStyle(color: Colors.white, fontSize: 24.0),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: myController,
                  expands: true,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Compose your message here...",
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                bottom: 20.0,
              ),
              width: double.infinity,
              child: CupertinoButton(
                child: Text('Send'),
                color: Theme.of(context).primaryColor,
                onPressed: handlePromptAnswer,
                borderRadius: BorderRadius.all(Radius.circular(1000.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handlePromptAnswer() {
    final PublicUserData user = context.read<PublicUserData>();
    final AnswerPromptScreenArguments args =
        ModalRoute.of(context).settings.arguments;

    Chat chat = args.chat;
    ChatMessage message = args.message;

    String response = myController.text;

    FirebaseDatabase.instance
        .reference()
        .child('chats')
        .child(chat.id)
        .child("messages")
        .child(message.id)
        .child("conversationPrompt")
        .child("responses")
        .child(user.id)
        .set(response)
        .then((value) {
      Navigator.pop(context);
    });
  }
}

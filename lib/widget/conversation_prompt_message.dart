import 'package:duochat/models.dart';
import 'package:duochat/screens/answer_prompt_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConversationPromptMessage extends StatelessWidget {
  final ChatMessage message;

  const ConversationPromptMessage({this.message});

  Widget buildUserIcon(String photoURL, bool answeredPrompt) {
    return Container(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(photoURL),
          ),
          if (answeredPrompt)
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(9, 175, 26, 0.61),
                shape: BoxShape.circle,
              ),
            ),
          if (answeredPrompt)
            Icon(
              Icons.check,
              color: Colors.white,
            ),
        ],
      ),
      width: 56.0,
      height: 56.0,
      padding: EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    PublicUserData userData =
        Provider.of<PublicUserData>(context, listen: false);
    Chat chat = Provider.of<Chat>(context, listen: false);

    if (chat == null) {
      throw "ConversationPromptMessage must be used within a Chat provider";
    }

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AnswerPromptScreen.id,
          arguments: AnswerPromptScreenArguments(this.message, chat),
        );
      },
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: Theme.of(context).primaryColor,
        ),
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        child: Column(
          children: <Widget>[
            Text(
              this.message.conversationPrompt.prompt,
              style: TextStyle(color: Colors.white, fontSize: 24.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // todo: this should really be the *other* person's photo URL, not the chat URL
                // todo: chat.id is wrong -- it needs to be the other participant ID
                buildUserIcon(
                    chat.photoURL,
                    this
                            .message
                            .conversationPrompt
                            .responses
                            ?.containsKey(chat.id) ??
                        false),
                SizedBox(width: 12.0),
                buildUserIcon(
                    userData.photoURL,
                    this
                            .message
                            .conversationPrompt
                            .responses
                            ?.containsKey(userData.id) ??
                        false),
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'package:duochat/models.dart';
import 'package:duochat/screens/answer_prompt_screen.dart';
import 'package:flutter/material.dart';

class ConversationPromptMessage extends StatelessWidget {
  final ConversationPrompt prompt;
  final Function onTap;

  const ConversationPromptMessage({this.prompt, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AnswerPromptScreen.id,
          arguments: AnswerPromptScreenArguments(this.prompt),
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
              prompt.prompt,
              style: TextStyle(color: Colors.white, fontSize: 24.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: CircleAvatar(
                    backgroundImage:
                        NetworkImage('https://picsum.photos/200/200'),
                  ),
                  width: 56.0,
                  height: 56.0,
                  padding: EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 12.0),
                Container(
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage('https://picsum.photos/200/200'),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(9, 175, 26, 0.61),
                          shape: BoxShape.circle,
                        ),
                      ),
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
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

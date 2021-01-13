import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models.dart';

class ChatMessages extends StatelessWidget {
  final List<dynamic> messages;

  const ChatMessages({this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int index) {
        final ChatMessage msg = messages[index];
        return buildChatMessage(context, msg);
      },
    );
  }

  Align buildChatMessage(BuildContext context, ChatMessage msg) {
    return Align(
      alignment:
          msg.sender.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: msg.sender.isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 4.0, left: 12.0, right: 12.0),
              child: Text(
                DateFormat("h:mm a").format(msg.timestamp),
                style: TextStyle(color: Colors.black54),
              ),
            ),
            Container(
              child: Text(
                msg.text,
                style: TextStyle(
                    color: msg.sender.isUser ? Colors.white : Colors.black87),
              ),
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              decoration: BoxDecoration(
                color: msg.sender.isUser
                    ? Theme.of(context).primaryColor
                    : Colors.grey[100],
                borderRadius: BorderRadius.all(Radius.circular(100.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:duochat/widget/conversation_prompt_message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models.dart';

class ChatMessages extends StatefulWidget {
  final List<dynamic> messages;

  const ChatMessages({this.messages});

  @override
  _ChatMessagesState createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  final ScrollController _scrollController = ScrollController();
  final _scrollMessageCt = 0;

  @override
  Widget build(BuildContext context) {
    if (_scrollMessageCt != widget.messages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 100), curve: Curves.fastOutSlowIn);
      });
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.messages.length,
      itemBuilder: (BuildContext context, int index) {
        if (widget.messages[index] is ConversationPrompt) {
          return ConversationPromptMessage(
            prompt: widget.messages[index],
            onTap: (ConversationPrompt prompt) {
              print("Prompt tapped: " + prompt.prompt);
            },
          );
        } else if (widget.messages[index] is ChatMessage) {
          final ChatMessage msg = widget.messages[index];
          return buildChatMessage(context, msg);
        } else {
          throw "Unknown message " + widget.messages[index];
        }
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

import 'package:duochat/screens/chat_screen.dart';
import 'package:flutter/material.dart';

import '../models.dart';

class ChatList extends StatelessWidget {
  final List<Chat> chats;

  const ChatList({this.chats});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (BuildContext context, int index) {
          final Chat chat = chats[index];
          final ChatMessage lastMessage = chats[index].messages.last;
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                ChatScreen.id,
                arguments: ChatScreenArguments(chat.id),
              );
            },
            child: Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFFFFFFEF), const Color(0xFFffd4d1)],
                ),
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(25.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 35.0,
                        backgroundImage: NetworkImage(
                            chat.photoURL ?? lastMessage.sender.photoURL),
                      ),
                      SizedBox(width: 15.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            chat.name,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 210,
                            child: Text(
                              lastMessage.text,
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text('3:45pm'),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        width: 40.0,
                        height: 20.0,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'NEW',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

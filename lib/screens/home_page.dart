import 'package:duochat/models.dart';
import 'package:duochat/screens/support_screen.dart';
import 'package:duochat/widget/chat_list.dart';
import 'package:duochat/widget/top_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TopNavBar(
              image: NetworkImage('https://picsum.photos/200/200'),
              title: 'DuoChat',
              suffix: CupertinoButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    SupportScreen.id,
                  );
                },
                child: Text(
                  'Support',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ),
            ChatList(
              chats: <Chat>[
                Chat(
                  name: 'Ian Chen',
                  id: 'ianchenchatid',
                  photoURL: null,
                  messages: <ChatMessage>[
                    ChatMessage(
                      sender: ChatMessageSender(
                        name: "Ian Chen",
                        photoURL:
                            'https://static.toiimg.com/thumb/msid-67586673,width-800,height-600,resizemode-75,imgsize-3918697,pt-32,y_pad-40/67586673.jpg',
                      ),
                      text: "Ian Chen invited you to chat!",
                      readBy: [
                        ChatMessageReadByUser(name: 'Nathan Wang', id: 'asdf'),
                      ],
                    ),
                  ],
                ),
                Chat(
                  name: 'MUN Officer Team',
                  id: 'uniqueid',
                  photoURL: 'https://picsum.photos/200',
                  messages: <ChatMessage>[
                    ChatMessage(
                      sender: ChatMessageSender(
                        name: "Parth Asawa",
                        photoURL: '',
                      ),
                      text: "Parth Asawa invited you to chat!",
                    ),
                  ],
                ),
                Chat(
                  name: 'Richard Liu',
                  id: 'uniqueid',
                  photoURL: null,
                  messages: <ChatMessage>[
                    ChatMessage(
                      sender: ChatMessageSender(
                        name: "Richard Liu",
                        photoURL: 'https://picsum.photos/200',
                      ),
                      text: "Richard Liu invited you to chat!",
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

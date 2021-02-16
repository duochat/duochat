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
                            'https://scontent-sjc3-1.xx.fbcdn.net/v/t1.0-1/p100x100/107569367_699524004113639_5166376271392046689_o.jpg?_nc_cat=102&_nc_sid=dbb9e7&_nc_ohc=Kem28j5_aiAAX91MwvD&_nc_ht=scontent-sjc3-1.xx&_nc_tp=6&oh=e8af1536be6e3299f2f20e897b4e5069&oe=5F52B67C',
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

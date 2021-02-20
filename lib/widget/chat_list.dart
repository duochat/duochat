import 'package:duochat/screens/chat_screen.dart';
import 'package:duochat/widget/user_card.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models.dart';

class ChatList extends StatelessWidget {
  final List<Chat> chats;

  const ChatList({this.chats});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: chats.length,
        //separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (BuildContext context, int index) {
          final Chat chat = chats[index];
          return StreamBuilder<dynamic>(
            stream: FirebaseDatabase.instance
                .reference()
                .child('chats')
                .child(chat.id)
                .child("messages")
                .onValue,
            builder: (context, snapshot) {
              String text = "Loading...";
              String time = "";

              if (snapshot.hasData) {
                List<ChatMessage> messages =
                (snapshot.data.snapshot.value ?? {})
                    .values
                    .map<ChatMessage>((message) =>
                    ChatMessage.fromMap(message))
                    .toList();
                messages.sort((a, b) =>
                    a.timestamp.compareTo(b.timestamp));
                if (messages.isEmpty) {
                  text = "Say hi to " + chat.name + "!";
                } else {
                  time = DateFormat('jm').format(messages.last.timestamp);
                  if(messages.last.text != null) {
                    text = messages.last.text;
                  } else if(messages.last.imageURL != null) {
                    text = '[${messages.last.sender.name} sent an image]';
                  } else {
                    text = 'Say hi to ${chat.name}!';
                  }
                }
              }

              return UserCard(
                user: PublicUserData(
                  name: chat.name,
                  photoURL: chat.photoURL,
                ),
                message: text,
                onTap: () => Navigator.pushNamed(
                  context,
                  ChatScreen.id,
                  arguments: ChatScreenArguments(chat),
                ),
                contextWidget: Column(
                 crossAxisAlignment: CrossAxisAlignment.end,
                 children: <Widget>[
                   Text(time),
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
              );
            });
//           return GestureDetector(
//             onTap: () {
//               Navigator.pushNamed(
//                 context,
//                 ChatScreen.id,
//                 arguments: ChatScreenArguments(chat),
//               );
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//               decoration: BoxDecoration(
// //                gradient: LinearGradient(
// //                  colors: [const Color(0xFFFFFFEF), const Color(0xFFffd4d1)],
// //                ),
// //                borderRadius: BorderRadius.horizontal(
// //                  right: Radius.circular(20.0),
// //                ),
//                   ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Row(
//                     children: <Widget>[
//                       CircleAvatar(
//                         radius: 30.0,
//                         backgroundImage: NetworkImage(chat.photoURL),
//                       ),
//                       SizedBox(width: 15.0),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text(
//                             chat.name,
//                             style: TextStyle(
//                               color: Colors.grey,
//                               fontSize: 15.0,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(
//                             height: 5.0,
//                           ),
//                           Container(
// //                            width: MediaQuery.of(context).size.width - 210,
//                             child: StreamBuilder<dynamic>(
//                                 stream: FirebaseDatabase.instance
//                                     .reference()
//                                     .child('chats')
//                                     .child(chat.id)
//                                     .child("messages")
//                                     .onValue,
//                                 builder: (context, snapshot) {
//                                   String text = "Loading...";
//
//                                   if (snapshot.hasData) {
//                                     List<ChatMessage> messages =
//                                         (snapshot.data.snapshot.value ?? {})
//                                             .values
//                                             .map<ChatMessage>((message) =>
//                                                 ChatMessage.fromMap(message))
//                                             .toList();
//                                     messages.sort((a, b) =>
//                                         a.timestamp.compareTo(b.timestamp));
//                                     if (messages.isEmpty) {
//                                       text = "Say hi to " + chat.name + "!";
//                                     } else {
//                                       text = messages.last.text;
//                                     }
//                                   }
//
//                                   return Text(
//                                     text,
//                                     style: TextStyle(
//                                       color: Colors.blueGrey,
//                                       fontSize: 15.0,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                     overflow: TextOverflow.ellipsis,
//                                   );
//                                 }),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
// //                  Column(
// //                    crossAxisAlignment: CrossAxisAlignment.end,
// //                    children: <Widget>[
// //                      Text('3:45pm'),
// //                      SizedBox(
// //                        height: 5.0,
// //                      ),
// //                      Container(
// //                        width: 40.0,
// //                        height: 20.0,
// //                        decoration: BoxDecoration(
// //                          color: Theme.of(context).primaryColor,
// //                          borderRadius: BorderRadius.circular(30.0),
// //                        ),
// //                        alignment: Alignment.center,
// //                        child: Text(
// //                          'NEW',
// //                          style: TextStyle(
// //                            color: Colors.white,
// //                            fontSize: 12.0,
// //                            fontWeight: FontWeight.bold,
// //                          ),
// //                        ),
// //                      ),
// //                    ],
// //                  ),
//                 ],
//               ),
//             ),
//           );
        },
      ),
    );
  }
}

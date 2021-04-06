import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:duochat/widget/chat_messages.dart';
import 'package:duochat/widget/top_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models.dart';

class ChatScreenArguments {
  final Chat chat;

  ChatScreenArguments(this.chat);
}

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FocusNode myFocusNode = FocusNode();
  final myController = TextEditingController();
  bool loading = true;
  PickedFile _image;

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
    myController.dispose();

    super.dispose();
  }

  Future chooseFile() async {
    try {
      await ImagePicker().getImage(source: ImageSource.gallery).then((image) {
        setState(() {
          _image = image;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future uploadFile(chatId) async {
    try {
      Random rnd = new Random();
      String ref = 'uploads/' +
          DateTime.now().microsecondsSinceEpoch.toString() +
          "--" +
          rnd.nextInt(100000).toString() +
          "--" +
          _image.path.replaceAll("/", "_");
      showAlertDialog(context);
      await firebase_storage.FirebaseStorage.instance
          .ref(ref)
          .putFile(File(_image.path));
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref(ref)
          .getDownloadURL();
      PublicUserData.fromID(FirebaseAuth.instance.currentUser.uid)
          .then((PublicUserData currentUser) {
        ChatMessage message = ChatMessage(
          sender: ChatMessageSender(
            name: currentUser.name,
            id: currentUser.id,
            photoURL: currentUser.photoURL,
          ),
          imageURL: downloadURL,
          timestamp: DateTime.now(),
          readBy: [ChatMessageReadByUser(name: "dfas", id: "sadf")],
        );
        FirebaseDatabase.instance
            .reference()
            .child('chats')
            .child(chatId)
            .child("messages")
            .push()
            .set(message.toMap());
        Navigator.pop(context);
      });
    } on firebase_core.FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e);
    }
    print("uploaded");
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 16), child: Text("Uploading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void handleChatMessageSubmit(String chatId) {
    if (myController.text.trim() == '') {
      myFocusNode.requestFocus();
      return;
    }

    final String text = myController.text;

    PublicUserData currentUser =
        Provider.of<PublicUserData>(context, listen: false);

    if (text == "prompt") {
      // temporary handling

      ChatMessage message = ChatMessage(
        sender: ChatMessageSender(
          name: currentUser.name,
          id: currentUser.id,
          photoURL: currentUser.photoURL,
        ),
        conversationPrompt: ConversationPrompt(
          prompt: "What's your most memorable memory?",
        ),
        timestamp: DateTime.now(),
        readBy: [ChatMessageReadByUser(name: "dfas", id: "sadf")],
      );
      FirebaseDatabase.instance
          .reference()
          .child('chats')
          .child(chatId)
          .child("messages")
          .push()
          .set(message.toMap());

      myController.clear();
      return;
    }

    ChatMessage message = ChatMessage(
      sender: ChatMessageSender(
        name: currentUser.name,
        id: currentUser.id,
        photoURL: currentUser.photoURL,
      ),
      text: text,
      timestamp: DateTime.now(),
      readBy: [ChatMessageReadByUser(name: "dfas", id: "sadf")],
    );
    FirebaseDatabase.instance
        .reference()
        .child('chats')
        .child(chatId)
        .child("messages")
        .push()
        .set(message.toMap());

    myController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final ChatScreenArguments args = ModalRoute.of(context).settings.arguments;
    final chatId = args.chat.id;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TopNavBar(
              image: NetworkImage(args.chat.photoURL),
              title: args.chat.name,
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
              child: StreamBuilder(
                stream: FirebaseDatabase.instance
                    .reference()
                    .child('chats')
                    .child(chatId)
                    .child("messages")
                    .onValue,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        ),
                      ),
                    );

                  List<ChatMessage> messages =
                      (snapshot.data.snapshot.value ?? {})
                          .values
                          .map<ChatMessage>(
                              (message) => ChatMessage.fromMap(message))
                          .toList();
                  messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

                  return NotificationListener<ScrollStartNotification>(
                    child: ChatMessages(messages: messages),
                    onNotification: (notification) {
                      myFocusNode.unfocus();
                      return true;
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  CupertinoButton(
                    child: Icon(Icons.image),
                    color: Colors.grey.shade500,
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                    onPressed: () async {
                      print("Send Image");
                      await chooseFile();
                      print("chosen");
                      await uploadFile(chatId);
                      print("upload");
                    },
                    padding: EdgeInsets.all(8.0),
                    minSize: 34.0,
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: CupertinoTextField(
                      controller: myController,
                      focusNode: myFocusNode,
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
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
                        handleChatMessageSubmit(chatId);
                      },
                    ),
                  ),
                  SizedBox(width: 5),
                  CupertinoButton(
                    child: Icon(Icons.arrow_upward),
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                    onPressed: () {
                      handleChatMessageSubmit(chatId);
                    },
                    padding: EdgeInsets.all(8.0),
                    minSize: 34.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

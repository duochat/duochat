import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:duochat/widget/chat_messages.dart';
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
  static const String id = 'chat_screen';

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
          sender: ChatMessageUser(
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
        sender: ChatMessageUser(
          name: currentUser.name,
          id: currentUser.id,
          photoURL: currentUser.photoURL,
        ),
        conversationPrompt: ConversationPrompt(
          prompt: "What's your favorite FBLA event?",
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
      sender: ChatMessageUser(
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

    return MultiProvider(
      providers: [Provider(create: (_) => args.chat)],
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 6.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.arrow_back,
                        size: 14.0,
                        color: Colors.grey[500],
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12.0),
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  color: Color(0xff227C9D),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(args.chat.photoURL),
                        ),
                        width: 50.0,
                        height: 50.0,
                        padding: EdgeInsets.all(1.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(
                        width: 12.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            args.chat.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 24.0,
                            ),
                          ),
                          SizedBox(height: 2.0),
                          Text(
                            'Level 9 | Question Streak: 4',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                      Expanded(child: Container()),
                      GestureDetector(
                        onTap: () {
                          print("Show today's question");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffFE6D73),
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.0)),
                          ),
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                "Today's\nQuestion",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 2.0),
                              Text(
                                "Now Viewing",
                                style: TextStyle(
                                  fontSize: 10.0,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
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
                            .entries
                            .map<ChatMessage>(
                                (entry) => ChatMessage.fromMapEntry(entry))
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
      ),
    );
  }
}

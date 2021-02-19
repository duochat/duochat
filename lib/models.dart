import 'package:cloud_firestore/cloud_firestore.dart';

class PrivateUserData {
  final String id;
  final DateTime createdTimestamp;
  final bool finishedOnboarding;
  final Set<String> outgoingRequests;
  final Set<String> incomingRequests;

  PrivateUserData({
    this.id,
    this.createdTimestamp,
    this.finishedOnboarding,
    this.outgoingRequests,
    this.incomingRequests
  });

  static Future<PrivateUserData> fromID(String id) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('privateUserInfo')
      .doc(id).get();
    return PrivateUserData(
      id: id,
      createdTimestamp: DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data()['createdAt'])),
      finishedOnboarding: snapshot.data()['finishedOnboarding'],
      outgoingRequests: (snapshot.data()['outgoingRequests'] ?? []).map<String>((s) => s.toString()).toSet(),
      incomingRequests: (snapshot.data()['incomingRequests'] ?? []).map<String>((s) => s.toString()).toSet(),
    );
  }

  Future<void> writeToDB() {
    return FirebaseFirestore.instance
      .collection('privateUserInfo')
      .doc(id)
      .update({
        'outgoingRequests': outgoingRequests.toList(),
        'incomingRequests': incomingRequests.toList(),
      });
  }

}

class PublicUserData {
  final String name;
  final String id;
  final String photoURL;
  final String username;
  final String bio;
  final Set<String> connections;

  //TODO: add stuff like bio, website, profession...

  PublicUserData({this.name, this.id, this.photoURL, this.username, this.bio, this.connections});

  factory PublicUserData.fromMap(Map data) {
    return PublicUserData(
      name: data['name'] ?? '',
      id: data['id'] ?? '',
      photoURL: data['photoURL'] ?? 'https://icon-library.com/images/default-profile-icon/default-profile-icon-16.jpg',
      username: data['username'] ?? '',
      bio: data['bio'] ?? "This user doesn't have a bio yet.",
      connections: (data['connections'] ?? []).map<String>((s) => s as String).toSet()
    );
  }

  static Future<PublicUserData> fromID(String id) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('publicUserInfo')
        .doc(id).get();
    return PublicUserData(
      id: id,
      name: snapshot.data()['name'] ?? 'No Name',
      photoURL: snapshot.data()['photoURL'] ?? 'https://icon-library.com/images/default-profile-icon/default-profile-icon-16.jpg',
      username: snapshot.data()['username'] ?? '_',
      bio: snapshot.data()['bio'] ?? "This user doesn't have a bio yet.",
      connections: (snapshot.data()['connections'] ?? []).map<String>((s) => s as String).toSet(),
    );
  }

  Future<void> writeToDB() {
    return FirebaseFirestore.instance
        .collection('publicUserInfo')
        .doc(id)
        .update({
      'name': name,
      'photoURL': photoURL,
      'username': username,
      'bio': bio,
      'connections': connections.toList(),
    });
  }

}

class Chat {
  final String name;
  final String id;
  final String photoURL;
  List<ChatMessage> messages;

  Chat({this.name, this.id, this.photoURL, this.messages});
  factory Chat.fromMap(Map data) {
    return Chat(
      name: data['name'] ?? '',
      photoURL: data['photoURL'] ?? '',
      id: data['id'] ?? '',
      messages: data['messages'].map((msg) => ChatMessage.fromMap(msg)) ?? '',
    );
  }
}

class ChatMessageSender {
  final String name;
  final String photoURL;
  final String id;
  final bool isUser;

  ChatMessageSender({this.name, this.photoURL, this.id, this.isUser});
  factory ChatMessageSender.fromMap(Map data) {
    return ChatMessageSender(
      name: data['name'] ?? '',
      photoURL: data['photoURL'] ?? '',
      id: data['id'] ?? '',
      isUser: data['isUser'] ?? '',
    );
  }
  toMap() {
    return {"name": name, "photoURL": photoURL, "id": id, "isUser": isUser};
  }
}

class ChatMessageReadByUser {
  final String name;
  final String id;

  ChatMessageReadByUser({this.name, this.id});
  factory ChatMessageReadByUser.fromMap(Map data) {
    return ChatMessageReadByUser(
      name: data['name'] ?? '',
      id: data['id'] ?? '',
    );
  }
  toMap() {
    return {"name": name, "id": id};
  }
}

class ChatMessage {
  final ChatMessageSender sender;
  final String text;
  final DateTime timestamp;
  final List<ChatMessageReadByUser> readBy;

  ChatMessage({this.sender, this.text, this.timestamp, this.readBy});
  factory ChatMessage.fromMap(Map data) {
    return ChatMessage(
      sender: ChatMessageSender.fromMap(data['sender']),
      text: data['text'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(data['timestamp']),
      readBy: data['readBy']
          .map<ChatMessageReadByUser>((el) => ChatMessageReadByUser.fromMap(el))
          .toList(),
    );
  }
  toMap() {
    return {
      "sender": sender.toMap(),
      "text": text,
      "timestamp": timestamp.millisecondsSinceEpoch,
      "readBy": readBy.map((el) => el.toMap()).toList()
    };
  }
}

class ConversationPrompt {
  final String prompt;

  ConversationPrompt(this.prompt);
}

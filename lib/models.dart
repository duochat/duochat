import 'package:cloud_firestore/cloud_firestore.dart';

class PrivateUserData {
  final String id;
  final DateTime createdTimestamp;
  final bool finishedOnboarding;
  final Set<String> outgoingRequests;
  final Set<String> incomingRequests;

  PrivateUserData(
      {this.id,
      this.createdTimestamp,
      this.finishedOnboarding,
      this.outgoingRequests,
      this.incomingRequests});

  static Future<PrivateUserData> fromID(String id) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('privateUserInfo')
        .doc(id)
        .get();
    return PrivateUserData(
      id: id,
      createdTimestamp: DateTime.fromMillisecondsSinceEpoch(
          int.parse(snapshot.data()['createdAt'])),
      finishedOnboarding: snapshot.data()['finishedOnboarding'],
      outgoingRequests: (snapshot.data()['outgoingRequests'] ?? [])
          .map<String>((s) => s.toString())
          .toSet(),
      incomingRequests: (snapshot.data()['incomingRequests'] ?? [])
          .map<String>((s) => s.toString())
          .toSet(),
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
  final String interests;
  final Set<String> connections;

  //TODO: add stuff like bio, website, profession...

  PublicUserData(
      {this.name,
      this.id,
      this.photoURL,
      this.username,
      this.bio,
      this.interests,
      this.connections});

  factory PublicUserData.fromMap(Map data) {
    return PublicUserData(
        name: data['name'] ?? '',
        id: data['id'] ?? '',
        photoURL: data['photoURL'] ??
            'https://icon-library.com/images/default-profile-icon/default-profile-icon-16.jpg',
        username: data['username'] ?? '',
        bio: data['bio'] ?? "This user doesn't have a bio yet.",
        interests: data['interests'] ?? "Business",
        connections: (data['connections'] ?? [])
            .map<String>((s) => s as String)
            .toSet());
  }

  static Future<PublicUserData> fromID(String id) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('publicUserInfo')
        .doc(id)
        .get();
    return PublicUserData(
      id: id,
      name: snapshot.data()['name'] ?? 'No Name',
      photoURL: snapshot.data()['photoURL'] ??
          'https://icon-library.com/images/default-profile-icon/default-profile-icon-16.jpg',
      username: snapshot.data()['username'] ?? '_',
      bio: snapshot.data()['bio'] ?? "This user doesn't have a bio yet.",
      interests: snapshot.data()['interests'] ?? "Business",
      connections: (snapshot.data()['connections'] ?? [])
          .map<String>((s) => s as String)
          .toSet(),
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
  final List<ChatMessageUser> participants;

  Chat({this.name, this.id, this.photoURL, this.participants});
  factory Chat.fromMap(Map data) {
    return Chat(
      name: data['name'] ?? '',
      photoURL: data['photoURL'] ?? '',
      id: data['id'] ?? '',
      participants: data['participants'] ?? [],
    );
  }
}

class ChatMessageUser {
  final String name;
  final String photoURL;
  final String id;

  ChatMessageUser({this.name, this.photoURL, this.id});
  factory ChatMessageUser.fromMap(Map data) {
    return ChatMessageUser(
      name: data['name'] ?? '',
      photoURL: data['photoURL'] ?? '',
      id: data['id'] ?? '',
    );
  }
  toMap() {
    return {"name": name, "photoURL": photoURL, "id": id};
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
  final String id;
  final ChatMessageUser sender;
  final String text;
  final String imageURL;
  final ConversationPrompt conversationPrompt;
  final DateTime timestamp;
  final List<ChatMessageReadByUser> readBy;

  ChatMessage(
      {this.id,
      this.sender,
      this.text,
      this.imageURL,
      this.conversationPrompt,
      this.timestamp,
      this.readBy});
  factory ChatMessage.fromMapEntry(MapEntry<dynamic, dynamic> entry) {
    Map data = entry.value;
    return ChatMessage(
      id: entry.key,
      sender: ChatMessageUser.fromMap(data['sender']),
      text: data['text'],
      imageURL: data['imageURL'],
      conversationPrompt: data['conversationPrompt'] == null
          ? null
          : ConversationPrompt.fromMap(data['conversationPrompt']),
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
      "imageURL": imageURL,
      "conversationPrompt": conversationPrompt?.toMap(),
      "timestamp": timestamp.millisecondsSinceEpoch,
      "readBy": readBy.map((el) => el.toMap()).toList()
    };
  }
}

class ConversationPrompt {
  final String prompt;
  final Map<String, String> responses;

  ConversationPrompt({this.prompt, this.responses});

  factory ConversationPrompt.fromMap(Map<dynamic, dynamic> data) {
    return ConversationPrompt(
        prompt: data['prompt'],
        responses: data['responses']?.cast<String, String>());
  }
  toMap() {
    return {
      "prompt": prompt,
      "responses": responses,
    };
  }
}


// This is for storing the user in smaller data (in searching and friend request)
// Doesn't have bio and stuff
class UserData {
  final String name;
  final String id;
  final String photoURL;
  final String username;

  UserData({this.name, this.id, this.photoURL, this.username});
}

class PublicUserData {
  final String name;
  final String id;
  final String photoURL;
  final String username;

  //TODO: add stuff like bio, website, profession...

  PublicUserData({this.name, this.id, this.photoURL, this.username});

  factory PublicUserData.fromMap(Map data) {
    return PublicUserData(
      name: data['name'] ?? '',
      id: data['id'] ?? '',
      photoURL: data['photoURL'] ?? '',
      username: data['username'] ?? '',
    );
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
      text: data['text'] ?? '',
      timestamp: data['timestamp'] ?? '',
      readBy: data['readBy'].map((el) => ChatMessageReadByUser.fromMap(el)),
    );
  }
}

class ConversationPrompt {
  final String prompt;

  ConversationPrompt(this.prompt);
}

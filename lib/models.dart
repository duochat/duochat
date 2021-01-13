class PublicUserData {
  final String name;
  final String id;
  final String photoURL;
  final String username;

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
}

class ChatMessageSender {
  final String name;
  final String photoURL;
  final String id;
  final bool isUser;

  ChatMessageSender({this.name, this.photoURL, this.id, this.isUser});
}

class ChatMessageReadByUser {
  final String name;
  final String id;

  ChatMessageReadByUser({this.name, this.id});
}

class ChatMessage {
  final ChatMessageSender sender;
  final String text;
  final DateTime timestamp;
  final List<ChatMessageReadByUser> readBy;

  ChatMessage({this.sender, this.text, this.timestamp, this.readBy});
}

class ConversationPrompt {
  final String prompt;

  ConversationPrompt(this.prompt);
}

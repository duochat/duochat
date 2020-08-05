class UserData {
  final String name;
  final String id;
  final String photoURL;
  final String username;

  UserData({this.name, this.id, this.photoURL, this.username});

  factory UserData.fromMap(Map data) {
    return UserData(
      name: data['name'] ?? '',
      id: data['id'] ?? '',
      photoURL: data['photoURL'] ?? '',
      username: data['username'] ?? '',
    );
  }
}

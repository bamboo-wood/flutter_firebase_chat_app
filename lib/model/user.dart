class User {
  String uid;
  String name;
  String? imagePath;
  String lastMessage;

  User({
    required this.name,
    required this.uid,
    this.imagePath,
    this.lastMessage = '',
  });
}

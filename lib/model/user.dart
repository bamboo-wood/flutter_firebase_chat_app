class User {
  String uid;
  String name;
  String? imagePath;

  User({
    required this.name,
    required this.uid,
    this.imagePath,
  });
}

class User {
  String name;
  String email;
  String avatar;
  String photo_path;

  User(
      {required this.name,
      required this.email,
      required this.avatar,
      required this.photo_path});

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        avatar = json['avatar'],
        photo_path = json['photo_path'];
}

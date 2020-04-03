class User {
  String email;
  String id;
  String photo;
  String username;
  String displayName;

  User({this.id, this.email, this.photo, this.displayName, this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      //email: json['id'],
      //photo: json['photo'],
      //id: json['userId'],
      //displayName: json['displayName']
    );
  }

  String get_id(User user) {
    return user.id;
  }

  String get_email(User user) {
    return user.email;
  }

  String get_photo(User user) {
    return user.photo;
  }

  static String get_username(User user) {
    return user.username;
  }

  String get_displayName(User user) {
    return user.displayName;
  }
}

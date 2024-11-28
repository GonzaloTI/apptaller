class User {
  int? id;
  String? name;
  String? email;
  String? role;
  String? token;

  User({this.id, this.name, this.email, this.role, this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['id'],
      name: json['user']['name'],
      email: json['user']['email'],
      role: json['user']['role'],
      token: json['token'],
    );
  }

  factory User.fromJsonUsers(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      // token: json['token'],
    );
  }
}

class User {
  int? id;
  String username;
  String password;
  String? displayName;
  String? createdAt;

  User({
    this.id,
    required this.username,
    required this.password,
    this.displayName,
    this.createdAt,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      username: map['username'] as String,
      password: map['password'] as String,
      displayName: map['display_name'] as String?,
      createdAt: map['created_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'username': username,
      'password': password,
      'display_name': displayName,
      'created_at': createdAt,
    };
  }
}

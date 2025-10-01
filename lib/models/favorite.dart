class Favorite {
  int? id;
  int postId;
  int userId;
  String? createdAt;

  Favorite({
    this.id,
    required this.postId,
    required this.userId,
    this.createdAt,
  });

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      id: map['id'] as int?,
      postId: map['post_id'] as int,
      userId: map['user_id'] as int,
      createdAt: map['created_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'post_id': postId,
      'user_id': userId,
      'created_at': createdAt,
    };
  }
}

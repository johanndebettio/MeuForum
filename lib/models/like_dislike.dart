class LikeDislike {
  int? id;
  int postId;
  int userId;
  int type;
  String? createdAt;

  LikeDislike({
    this.id,
    required this.postId,
    required this.userId,
    required this.type,
    this.createdAt,
  });

  factory LikeDislike.fromMap(Map<String, dynamic> map) {
    return LikeDislike(
      id: map['id'] as int?,
      postId: map['post_id'] as int,
      userId: map['user_id'] as int,
      type: map['type'] as int,
      createdAt: map['created_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'post_id': postId,
      'user_id': userId,
      'type': type,
      'created_at': createdAt,
    };
  }
}

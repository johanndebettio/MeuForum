class Comment {
  int? id;
  int postId;
  int userId;
  String content;
  String? createdAt;
  String? userDisplayName;
  String? gifUrl; // URL do GIF anexado

  Comment({
    this.id,
    required this.postId,
    required this.userId,
    required this.content,
    this.createdAt,
    this.userDisplayName,
    this.gifUrl,
  });

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as int?,
      postId: map['post_id'] as int,
      userId: map['user_id'] as int,
      content: map['content'] as String,
      createdAt: map['created_at'] as String?,
      userDisplayName: map['userDisplayName'] as String?,
      gifUrl: map['gif_url'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'post_id': postId,
      'user_id': userId,
      'content': content,
      'created_at': createdAt,
      'gif_url': gifUrl,
    };
  }
}

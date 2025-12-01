class Post {
  int? id;
  int userId;
  String title;
  String? content;
  String? createdAt;
  String? userDisplayName;
  String? imagePath; // Caminho da imagem anexada ao post

  Post({
    this.id,
    required this.userId,
    required this.title,
    this.content,
    this.createdAt,
    this.userDisplayName,
    this.imagePath,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      title: map['title'] as String,
      content: map['content'] as String?,
      createdAt: map['created_at'] as String?,
      userDisplayName: map['user_display_name'] as String?,
      imagePath: map['image_path'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
      'created_at': createdAt,
      'image_path': imagePath,
    };
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../providers/post_provider.dart';
import '../widgets/post_card.dart';
import 'post_detail_page.dart';

class AllPostsPage extends StatelessWidget {
  final User user;
  final Function(Post) onDelete;
  final String Function(String) formatDate;

  const AllPostsPage({
    super.key,
    required this.user,
    required this.onDelete,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<PostProvider>();

    if (postProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (postProvider.errorMessage != null) {
      return Center(child: Text(postProvider.errorMessage!));
    }

    final posts = postProvider.posts;
    if (posts.isEmpty) {
      return const Center(child: Text('Nenhum post disponível.'));
    }

    return RefreshIndicator(
      onRefresh: postProvider.loadPosts,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: posts.length,
        itemBuilder: (_, i) {
          final post = posts[i];
          final canDelete =
              user.username.toLowerCase() == 'johan' || post.userId == user.id;

          return PostCard(
            post: post,
            formatDate: formatDate,
            canDelete: canDelete,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PostDetailPage(post: post, user: user),
                ),
              );
              await postProvider.loadPosts();
            },
            onDelete: canDelete ? () => onDelete(post) : null,
          );
        },
      ),
    );
  }
}

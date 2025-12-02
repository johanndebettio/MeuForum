import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../providers/post_provider.dart';
import '../widgets/post_card.dart';
import 'post_detail_page.dart';

class MyPostsPage extends StatefulWidget {
  final User user;
  final Function(Post) onDelete;
  final String Function(String) formatDate;

  const MyPostsPage({
    super.key,
    required this.user,
    required this.onDelete,
    required this.formatDate,
  });

  @override
  State<MyPostsPage> createState() => _MyPostsPageState();
}

class _MyPostsPageState extends State<MyPostsPage> {
  @override
  void initState() {
    super.initState();
    context.read<PostProvider>().loadPostsByUser(widget.user.id!);
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<PostProvider>();
    final posts = postProvider.userPosts;

    if (postProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (posts.isEmpty) {
      return const Center(child: Text('Nenhum post seu encontrado.'));
    }

    return RefreshIndicator(
      onRefresh: () => postProvider.loadPostsByUser(widget.user.id!),
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: posts.length,
        itemBuilder: (_, i) {
          final post = posts[i];
          final canDelete = widget.user.username.toLowerCase() == 'johan' ||
              post.userId == widget.user.id;

          return PostCard(
            post: post,
            formatDate: widget.formatDate,
            canDelete: canDelete,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      PostDetailPage(post: post, user: widget.user),
                ),
              );
              await postProvider.loadPostsByUser(widget.user.id!);
            },
            onDelete: canDelete ? () => widget.onDelete(post) : null,
          );
        },
      ),
    );
  }
}

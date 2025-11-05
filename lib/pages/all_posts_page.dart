import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../providers/post_provider.dart';
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

          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PostDetailPage(post: post, user: user),
                ),
              );
              await postProvider.loadPosts();
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Título:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700])),
                    Text(post.title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    Text('Autor:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700])),
                    Text(post.userDisplayName ?? 'Desconhecido',
                        style: const TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 14)),
                    const SizedBox(height: 8),
                    Text('Conteúdo:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700])),
                    Text(post.content ?? '',
                        style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 8),
                    if (post.createdAt != null)
                      Text(
                        'Criado em: ${formatDate(post.createdAt!)}',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    if (canDelete)
                      Align(
                        alignment: Alignment.topCenter,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => onDelete(post),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

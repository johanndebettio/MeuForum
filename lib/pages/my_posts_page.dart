import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../models/post.dart';
import '../providers/post_provider.dart';
import 'post_detail_page.dart';

class MyPostsPage extends StatefulWidget {
  final User user;
  final VoidCallback refresh;
  const MyPostsPage({super.key, required this.user, required this.refresh});

  @override
  State<MyPostsPage> createState() => _MyPostsPageState();
}

class _MyPostsPageState extends State<MyPostsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _animController.forward();

    Future.microtask(() {
      if (widget.user.id != null) {
        // ignore: use_build_context_synchronously
        context.read<PostProvider>().loadPostsByUser(widget.user.id!);
      }
    });
  }

  void _deletePost(Post post) async {
    final canDelete = widget.user.username.toLowerCase() == 'johan' ||
        post.userId == widget.user.id;

    if (!canDelete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você não pode deletar este post')),
      );
      return;
    }

    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Deletar Post'),
        content: const Text('Tem certeza que deseja deletar este post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Deletar'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // ignore: use_build_context_synchronously
    await context.read<PostProvider>().deletePost(post.id!);
    widget.refresh();
  }

  String _formatDate(String isoDate) {
    final date = DateTime.tryParse(isoDate);
    if (date == null) return isoDate;
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<PostProvider>();
    final posts = postProvider.posts;
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 600;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: postProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : postProvider.errorMessage != null
              ? Center(child: Text(postProvider.errorMessage!))
              : ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? width * 0.2 : 16,
                    vertical: 8,
                  ),
                  itemCount: posts.length,
                  itemBuilder: (_, i) {
                    final post = posts[i];
                    final canDelete =
                        widget.user.username.toLowerCase() == 'johan' ||
                            post.userId == widget.user.id;

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Título:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(post.title,
                                style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 8),
                            const Text('Autor:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(post.userDisplayName ?? 'Desconhecido',
                                style: const TextStyle(
                                    fontSize: 14, fontStyle: FontStyle.italic)),
                            const SizedBox(height: 8),
                            const Text('Conteúdo:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(post.content ?? '',
                                style: const TextStyle(fontSize: 14)),
                            const SizedBox(height: 8),
                            if (post.createdAt != null)
                              Text('Criado em: ${_formatDate(post.createdAt!)}',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        trailing: canDelete
                            ? IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deletePost(post),
                              )
                            : null,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PostDetailPage(post: post, user: widget.user),
                            ),
                          );
                          if (widget.user.id != null) {
                            // ignore: use_build_context_synchronously
                            context
                                .read<PostProvider>()
                                .loadPostsByUser(widget.user.id!);
                          }
                          widget.refresh();
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

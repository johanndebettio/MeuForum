import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/post.dart';
import '../repositories/post_repository.dart';
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
  final _postRepo = PostRepository();
  List<Post> _myPosts = [];
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  bool _loading = false;

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
    _loadMyPosts();
  }

  void _loadMyPosts() async {
    setState(() => _loading = true);
    try {
      if (widget.user.id == null) {
        setState(() => _myPosts = []);
        return;
      }

      final posts = await _postRepo.getPostsByUser(widget.user.id!);
      setState(() => _myPosts = posts);
    } catch (_) {
      setState(() => _myPosts = []);
    } finally {
      setState(() => _loading = false);
    }
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

    await _postRepo.deletePost(post.id!);
    _loadMyPosts();
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
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 600;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? width * 0.2 : 16,
                vertical: 8,
              ),
              itemCount: _myPosts.length,
              itemBuilder: (_, i) {
                final post = _myPosts[i];
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
                        Text(post.title, style: const TextStyle(fontSize: 16)),
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
                            icon: const Icon(Icons.delete, color: Colors.red),
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
                      _loadMyPosts();
                      widget.refresh();
                    },
                  ),
                );
              },
            ),
    );
  }
}

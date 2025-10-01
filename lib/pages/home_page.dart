import 'package:flutter/material.dart';
import 'package:meu_forum/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../models/post.dart';
import '../repositories/post_repository.dart';
import 'create_post_page.dart';
import 'post_detail_page.dart';
import 'reset_database_page.dart';
import 'login_page.dart';
import 'favorites_page.dart';
import 'my_posts_page.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _postRepo = PostRepository();
  List<Post> _posts = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  void _loadPosts() async {
    final posts = await _postRepo.getAllPosts();
    setState(() => _posts = posts);
  }

  void _logout() async {
    await Provider.of<UserProvider>(context, listen: false).logout();
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  void _goToCreatePost() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CreatePostPage(user: widget.user)),
    );
    _loadPosts();
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

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar deleção'),
        content: const Text('Deseja realmente deletar este post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Deletar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _postRepo.deletePost(post.id!);
      _loadPosts();
    }
  }

  String _formatDate(String isoDate) {
    final date = DateTime.tryParse(isoDate);
    if (date == null) return isoDate;
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  List<Widget> _pages() => [
        _buildPostsList(_posts),
        MyPostsPage(user: widget.user, refresh: _loadPosts),
        FavoritesPage(user: widget.user, refresh: _loadPosts),
      ];

  Widget _buildPostsList(List<Post> posts) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 600;

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: posts.length,
      itemBuilder: (_, index) {
        final post = posts[index];
        final canDelete = widget.user.username.toLowerCase() == 'johan' ||
            post.userId == widget.user.id;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 4, offset: Offset(2, 2)),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
                horizontal: isWide ? 24 : 16, vertical: 12),
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
                Text(post.content ?? '', style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 8),
                if (post.createdAt != null)
                  Text('Criado em: ${_formatDate(post.createdAt!)}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PostDetailPage(post: post, user: widget.user),
                ),
              );
              _loadPosts();
            },
            trailing: canDelete
                ? IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deletePost(post),
                    tooltip: 'Deletar Post',
                  )
                : null,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Fórum'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Sair',
            onPressed: _logout,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Criar Post',
            onPressed: _goToCreatePost,
          ),
          if (widget.user.username.toLowerCase() == 'johan')
            IconButton(
              icon: const Icon(Icons.warning, color: Colors.red),
              tooltip: 'Resetar Banco',
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ResetDatabasePage()),
                );
                _loadPosts();
              },
            ),
        ],
      ),
      body: _pages()[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Todos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Meus Posts'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favoritos'),
        ],
      ),
    );
  }
}

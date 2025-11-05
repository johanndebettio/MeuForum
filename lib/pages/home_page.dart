import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../models/post.dart';
import '../providers/post_provider.dart';
import '../providers/user_provider.dart';
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
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // ignore: use_build_context_synchronously
    Future.microtask(() => context.read<PostProvider>().loadPosts());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _logout() async {
    await context.read<UserProvider>().logout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  void _goToCreatePost() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CreatePostPage(user: widget.user)),
    );
    if (!mounted) return;
    context.read<PostProvider>().loadPosts();
  }

  void _deletePost(Post post) async {
    final user = widget.user;
    final canDelete =
        user.username.toLowerCase() == 'johan' || post.userId == user.id;

    if (!canDelete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você não pode deletar este post!')),
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
      if (!mounted) return;
      await context.read<PostProvider>().deletePost(post.id!);
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
        _buildPostsList(),
        MyPostsPage(
          user: widget.user,
          refresh: () => context.read<PostProvider>().loadPosts(),
        ),
        FavoritesPage(
          user: widget.user,
          refresh: () => context.read<PostProvider>().loadPosts(),
        ),
      ];

  Widget _buildPostsList() {
    final postProvider = context.watch<PostProvider>();
    final posts = postProvider.posts;
    final isLoading = postProvider.isLoading;
    final error = postProvider.errorMessage;
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 600;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text(error));
    }

    if (posts.isEmpty) {
      return const Center(child: Text('Nenhum post encontrado.'));
    }

    return RefreshIndicator(
      onRefresh: () => context.read<PostProvider>().loadPosts(),
      child: ListView.builder(
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
                  Text(post.content ?? '',
                      style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 8),
                  if (post.createdAt != null)
                    Text('Criado em: ${_formatDate(post.createdAt!)}',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        PostDetailPage(post: post, user: widget.user),
                  ),
                );
                if (!mounted) return;
                context.read<PostProvider>().loadPosts();
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
      ),
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
                if (!mounted) return;
                // ignore: use_build_context_synchronously
                context.read<PostProvider>().loadPosts();
              },
            ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        children: _pages(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() => _currentIndex = i);
          _pageController.animateToPage(
            i,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
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

import 'package:flutter/material.dart';
import 'package:meu_forum/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../providers/post_provider.dart';
import '../utils/image_storage_helper.dart';
import 'all_posts_page.dart';
import 'favorites_page.dart';
import 'my_posts_page.dart';
import 'create_post_page.dart';
import 'login_page.dart';
import 'reset_database_page.dart';
import 'settings_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostProvider>().loadPosts();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _formatDate(String isoDate) {
    final date = DateTime.tryParse(isoDate);
    if (date == null) return isoDate;
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Future<void> _deletePost(Post post) async {
    final postProvider = context.read<PostProvider>();
    final canDelete = widget.user.username.toLowerCase() == 'johan' ||
        post.userId == widget.user.id;

    if (!canDelete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você não pode deletar este post!')),
      );
      return;
    }

    final confirm = await showDialog<bool>(
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
            child: const Text('Deletar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await postProvider.deletePost(post.id!);
      await postProvider.loadPosts();
    }
  }

  void _logout() async {
    await context.read<UserProvider>().logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  List<Widget> _buildPages() => [
        AllPostsPage(
          user: widget.user,
          onDelete: _deletePost,
          formatDate: _formatDate,
        ),
        MyPostsPage(
          user: widget.user,
          onDelete: _deletePost,
          formatDate: _formatDate,
        ),
        FavoritesPage(
          user: widget.user,
          onDelete: _deletePost,
          formatDate: _formatDate,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final titles = ['Todos os Posts', 'Meus Posts', 'Favoritos'];
    final isJohan = widget.user.username.toLowerCase() == 'johan';
    final user = context.watch<UserProvider>().user ?? widget.user;
    final imageFile = ImageStorageHelper.getImageFile(user.profileImagePath);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(titles[_selectedIndex]),
        actions: [
          // Menu com foto de perfil
          PopupMenuButton<String>(
            offset: const Offset(0, 50),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[300],
                backgroundImage: imageFile != null && imageFile.existsSync()
                    ? FileImage(imageFile)
                    : null,
                child: imageFile == null || !imageFile.existsSync()
                    ? Icon(Icons.person, size: 20, color: Colors.grey[600])
                    : null,
              ),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 12),
                    Text('Meu Perfil'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 12),
                    Text('Configurações'),
                  ],
                ),
              ),
              if (isJohan)
                const PopupMenuItem(
                  value: 'reset',
                  child: Row(
                    children: [
                      Icon(Icons.restore),
                      SizedBox(width: 12),
                      Text('Resetar BD'),
                    ],
                  ),
                ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Sair', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfilePage(user: user),
                    ),
                  );
                  break;
                case 'settings':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SettingsPage(),
                    ),
                  );
                  break;
                case 'reset':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ResetDatabasePage(),
                    ),
                  );
                  break;
                case 'logout':
                  _logout();
                  break;
              }
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _selectedIndex = index),
        children: _buildPages(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          _pageController.jumpToPage(index);
          setState(() => _selectedIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'Todos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Meus',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0 || _selectedIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreatePostPage(user: widget.user),
                  ),
                );
                // ignore: use_build_context_synchronously
                await context.read<PostProvider>().loadPosts();
              },
              icon: const Icon(Icons.add),
              label: const Text('Novo Post'),
            )
          : null,
    );
  }
}

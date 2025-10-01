import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/post.dart';
import '../repositories/post_repository.dart';
import '../repositories/favorite_repository.dart';
import 'post_detail_page.dart';

class FavoritesPage extends StatefulWidget {
  final User user;
  final VoidCallback refresh;
  const FavoritesPage({super.key, required this.user, required this.refresh});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final _postRepo = PostRepository();
  final _favRepo = FavoriteRepository();
  List<Post> _favoritesPosts = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    final ids = await _favRepo.getFavoritePostIds(widget.user.id!);
    final allPosts = await _postRepo.getAllPosts();
    setState(() {
      _favoritesPosts = allPosts.where((p) => ids.contains(p.id)).toList();
    });
  }

  String _formatDate(String isoDate) {
    final date = DateTime.tryParse(isoDate);
    if (date == null) return isoDate;
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 600;

    return _favoritesPosts.isEmpty
        ? const Center(child: Text('Nenhum favorito ainda.'))
        : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _favoritesPosts.length,
            itemBuilder: (_, i) {
              final post = _favoritesPosts[i];
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
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
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
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
                    _loadFavorites();
                    widget.refresh();
                  },
                ),
              );
            },
          );
  }
}

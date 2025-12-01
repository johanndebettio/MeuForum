import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../providers/post_provider.dart';
import '../widgets/post_card.dart';
import 'post_detail_page.dart';

class FavoritesPage extends StatefulWidget {
  final User user;
  final Function(Post) onDelete;
  final String Function(String) formatDate;

  const FavoritesPage({
    super.key,
    required this.user,
    required this.onDelete,
    required this.formatDate,
  });

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    context.read<PostProvider>().loadFavoritePosts(widget.user.id!);
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<PostProvider>();
    final favorites = postProvider.favoritePosts;

    if (postProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (favorites.isEmpty) {
      return const Center(child: Text('Nenhum post favorito.'));
    }

    return RefreshIndicator(
      onRefresh: () => postProvider.loadFavoritePosts(widget.user.id!),
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: favorites.length,
        itemBuilder: (_, i) {
          final post = favorites[i];
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
              await postProvider.loadFavoritePosts(widget.user.id!);
            },
            onDelete: canDelete ? () => widget.onDelete(post) : null,
          );
        },
      ),
    );
  }
}

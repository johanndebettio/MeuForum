import 'package:flutter/material.dart';
import '../models/post.dart';
import '../repositories/post_repository.dart';
import '../repositories/favorite_repository.dart';

class PostProvider extends ChangeNotifier {
  final _postRepo = PostRepository();
  final _favRepo = FavoriteRepository();

  List<Post> _posts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> loadPosts() async {
    _setLoading(true);
    try {
      _posts = await _postRepo.getAllPosts();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Erro ao carregar posts: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadPostsByUser(int userId) async {
    _setLoading(true);
    try {
      _posts = await _postRepo.getPostsByUser(userId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Erro ao carregar posts do usuário: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadFavoritePosts(int userId) async {
    _setLoading(true);
    try {
      final favIds = await _favRepo.getFavoritePostIds(userId);
      final allPosts = await _postRepo.getAllPosts();
      _posts = allPosts.where((p) => favIds.contains(p.id)).toList();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Erro ao carregar favoritos: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deletePost(int id) async {
    _setLoading(true);
    try {
      await _postRepo.deletePost(id);
      _posts.removeWhere((p) => p.id == id);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Erro ao deletar post: $e';
    } finally {
      _setLoading(false);
    }
  }
}

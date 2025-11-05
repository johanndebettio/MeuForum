import 'package:flutter/material.dart';
import '../models/post.dart';
import '../repositories/post_repository.dart';
import '../repositories/favorite_repository.dart';

class PostProvider extends ChangeNotifier {
  final _postRepo = PostRepository();
  final _favRepo = FavoriteRepository();

  List<Post> _allPosts = [];
  List<Post> _userPosts = [];
  List<Post> _favoritePosts = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<Post> get posts => _allPosts;
  List<Post> get userPosts => _userPosts;
  List<Post> get favoritePosts => _favoritePosts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> loadPosts() async {
    _setLoading(true);
    try {
      _allPosts = await _postRepo.getAllPosts();
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
      _userPosts = await _postRepo.getPostsByUser(userId);
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
      _favoritePosts = allPosts.where((p) => favIds.contains(p.id)).toList();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Erro ao carregar favoritos: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createPost(Post post) async {
    _setLoading(true);
    try {
      final id = await _postRepo.createPost(post);

      final newPost = Post(
        id: id,
        userId: post.userId,
        title: post.title,
        content: post.content,
        createdAt: post.createdAt,
        userDisplayName: post.userDisplayName,
      );

      _allPosts.insert(0, newPost);
      _userPosts.insert(0, newPost);
      _errorMessage = null;

      notifyListeners();
    } catch (e) {
      _errorMessage = 'Erro ao criar post: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deletePost(int id) async {
    _setLoading(true);
    try {
      await _postRepo.deletePost(id);
      _allPosts.removeWhere((p) => p.id == id);
      _userPosts.removeWhere((p) => p.id == id);
      _favoritePosts.removeWhere((p) => p.id == id);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Erro ao deletar post: $e';
    } finally {
      _setLoading(false);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../models/comment.dart';
import '../repositories/comment_repository.dart';
import '../repositories/like_dislike_repository.dart';
import '../repositories/favorite_repository.dart';
import '../repositories/post_repository.dart';
import '../utils/form_validator.dart';
import '../utils/image_storage_helper.dart';

class PostDetailPage extends StatefulWidget {
  final Post post;
  final User user;

  const PostDetailPage({super.key, required this.post, required this.user});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage>
    with SingleTickerProviderStateMixin {
  final _commentController = TextEditingController();
  final _commentRepo = CommentRepository();
  final _likeRepo = LikeDislikeRepository();
  final _favRepo = FavoriteRepository();
  final _postRepo = PostRepository();
  final _formValidator = FormValidator();

  List<Comment> _comments = [];
  bool _isFavorited = false;
  int _likesCount = 0;
  int? _userReaction;
  bool _loading = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  bool get _canDeletePost =>
      widget.user.username.toLowerCase() == 'johan' ||
      widget.user.id == widget.post.userId;

  bool _canDeleteComment(Comment comment) =>
      widget.user.username.toLowerCase() == 'johan' ||
      comment.userId == widget.user.id;

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
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final comments = await _commentRepo.getCommentsByPost(widget.post.id!);
    final isFav = await _favRepo.isFavorited(widget.user.id!, widget.post.id!);
    final likes = await _likeRepo.getLikesCount(widget.post.id!);
    final reaction =
        await _likeRepo.getUserReaction(widget.user.id!, widget.post.id!);
    setState(() {
      _comments = comments;
      _isFavorited = isFav;
      _likesCount = likes;
      _userReaction = reaction;
      _loading = false;
    });
  }

  Future<void> _toggleFavorite() async {
    _isFavorited
        ? await _favRepo.unfavorite(widget.user.id!, widget.post.id!)
        : await _favRepo.favorite(widget.user.id!, widget.post.id!);
    _loadData();
  }

  Future<void> _handleReaction(int value) async {
    if (_userReaction == value) {
      await _likeRepo.removeReaction(widget.user.id!, widget.post.id!);
    } else {
      await _likeRepo.likeDislike(widget.user.id!, widget.post.id!, value);
    }
    _loadData();
  }

  Future<void> _addComment() async {
    final text = _commentController.text.trim();

    // Validar campos -- comentario
    _formValidator.validateCommentForm(text);

    if (!_formValidator.isValid) {
      setState(() {});
      return;
    }

    await _commentRepo.createComment(Comment(
      postId: widget.post.id!,
      userId: widget.user.id!,
      content: text,
    ));

    _commentController.clear();
    _loadData();
  }

  Future<void> _deleteComment(Comment comment) async {
    await _commentRepo.deleteComment(comment.id!, widget.user.username);
    _loadData();
  }

  Future<void> _deletePost() async {
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
            child: const Text('Deletar'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await _postRepo.deletePost(widget.post.id!);
    if (mounted) Navigator.pop(context);
  }

  void _sharePost() {
    final text = '''
📝 ${widget.post.title}

${widget.post.content ?? ''}

Por: ${widget.post.userDisplayName ?? 'Desconhecido'}
''';
    Share.share(text, subject: widget.post.title);
  }

  @override
  void dispose() {
    _animController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 600;
    final imageFile = ImageStorageHelper.getImageFile(widget.post.imagePath);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Post'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _sharePost,
            tooltip: 'Compartilhar',
          ),
          IconButton(
            icon: Icon(_isFavorited ? Icons.star : Icons.star_border),
            onPressed: _toggleFavorite,
            tooltip: _isFavorited ? 'Remover dos favoritos' : 'Favoritar',
          ),
          if (_canDeletePost)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _deletePost,
              tooltip: 'Deletar post',
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? width * 0.2 : 16,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    // Título
                    Text(
                      widget.post.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Conteúdo e Imagem
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Conteúdo do post
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.post.content ?? '',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Autor: ${widget.post.userDisplayName ?? "Desconhecido"}',
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Imagem (se existir) ao lado direito
                        if (imageFile != null && imageFile.existsSync()) ...[
                          const SizedBox(width: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              imageFile,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Botões de like/dislike
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.thumb_up,
                            color:
                                _userReaction == 1 ? Colors.blue : Colors.grey,
                          ),
                          onPressed: () => _handleReaction(1),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.thumb_down,
                            color:
                                _userReaction == -1 ? Colors.blue : Colors.grey,
                          ),
                          onPressed: () => _handleReaction(-1),
                        ),
                        Text('Likes: $_likesCount'),
                      ],
                    ),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _comments.length,
                        itemBuilder: (_, i) {
                          final c = _comments[i];
                          return ListTile(
                            title: Text(
                              '${c.userDisplayName ?? "Usuário"}: ${c.content}',
                            ),
                            trailing: _canDeleteComment(c)
                                ? IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _deleteComment(c),
                                  )
                                : null,
                          );
                        },
                      ),
                    ),
                    TextField(
                      controller: _commentController,
                      onChanged: (_) {
                        _formValidator.clearError('content');
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: 'Adicionar comentário',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: _addComment,
                        ),
                        border: const OutlineInputBorder(),
                        errorText: _formValidator.getError('content'),
                        helperText: 'Máximo 500 caracteres',
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

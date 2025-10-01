import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/post.dart';
import '../repositories/post_repository.dart';

class CreatePostPage extends StatefulWidget {
  final User user;
  const CreatePostPage({super.key, required this.user});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage>
    with SingleTickerProviderStateMixin {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _postRepo = PostRepository();

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnimation =
        CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _createPost() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty) {
      _showMessage('O título é obrigatório');
      return;
    }

    if (widget.user.id == null) {
      _showMessage('Usuário não identificado');
      return;
    }

    try {
      final post = Post(
        userId: widget.user.id!,
        title: title,
        content: content.isEmpty ? null : content,
        createdAt: DateTime.now().toIso8601String(),
      );

      await _postRepo.createPost(post);
      _showMessage('Post criado com sucesso!');
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      _showMessage('Erro ao criar post');
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 600;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Scaffold(
        appBar: AppBar(title: const Text('Criar Post')),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            width: isWide ? 600 : double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Conteúdo',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _createPost,
                    icon: const Icon(Icons.send),
                    label: const Text('Criar Post',
                        style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

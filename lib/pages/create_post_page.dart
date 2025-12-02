import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../models/post.dart';
import '../providers/post_provider.dart';
import '../utils/form_validator.dart';
import '../utils/image_picker_helper.dart';
import '../utils/image_storage_helper.dart';

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
  final _formValidator = FormValidator();
  final _imagePickerHelper = ImagePickerHelper();

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
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

    _formValidator.validatePostForm(title, content.isEmpty ? null : content);

    if (!_formValidator.isValid) {
      setState(() {});
      return;
    }

    if (widget.user.id == null) {
      _showMessage('Usuário não identificado');
      return;
    }

    try {
      String? imagePath;
      
      // Se há uma imagem selecionada, salva ela
      if (_selectedImage != null) {
        imagePath = await ImageStorageHelper.saveImage(
          _selectedImage!,
          customName: 'post_${DateTime.now().millisecondsSinceEpoch}${_selectedImage!.path.substring(_selectedImage!.path.lastIndexOf('.'))}',
        );
      }

      final post = Post(
        userId: widget.user.id!,
        title: title,
        content: content.isEmpty ? null : content,
        createdAt: DateTime.now().toIso8601String(),
        userDisplayName: widget.user.displayName,
        imagePath: imagePath,
      );

      await context.read<PostProvider>().createPost(post);

      _showMessage('Post criado com sucesso!');
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } catch (e) {
      _showMessage('Erro ao criar post: $e');
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _pickImage() async {
    final image = await _imagePickerHelper.pickImageWithDialog(context);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 600;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Scaffold(
        appBar: AppBar(title: const Text('Criar Post')),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              width: isWide ? 600 : double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    onChanged: (_) {
                      _formValidator.clearError('title');
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      labelText: 'Título',
                      border: const OutlineInputBorder(),
                      errorText: _formValidator.getError('title'),
                      helperText: 'Entre 5 e 100 caracteres',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _contentController,
                    onChanged: (_) {
                      _formValidator.clearError('content');
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      labelText: 'Conteúdo (opcional)',
                      border: const OutlineInputBorder(),
                      errorText: _formValidator.getError('content'),
                      helperText: 'Máximo 5000 caracteres',
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 16),
                  // Seção de imagem
                  if (_selectedImage != null)
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: _removeImage,
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    OutlinedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.image),
                      label: const Text('Adicionar Imagem (opcional)'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _createPost,
                      icon: const Icon(Icons.send),
                      label: const Text(
                        'Criar Post',
                        style: TextStyle(fontSize: 18),
                      ),
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
      ),
    );
  }
}

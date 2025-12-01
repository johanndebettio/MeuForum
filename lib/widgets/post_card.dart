import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/post.dart';
import '../utils/image_storage_helper.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final String Function(String) formatDate;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final bool canDelete;

  const PostCard({
    super.key,
    required this.post,
    required this.formatDate,
    required this.onTap,
    this.onDelete,
    this.canDelete = false,
  });

  void _sharePost() {
    final text = '''
📝 ${post.title}

${post.content ?? ''}

Por: ${post.userDisplayName ?? 'Desconhecido'}
''';
    Share.share(text, subject: post.title);
  }

  @override
  Widget build(BuildContext context) {
    final imageFile = ImageStorageHelper.getImageFile(post.imagePath);
    
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do post se existir
            if (imageFile != null && imageFile.existsSync())
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.file(
                  imageFile,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Autor
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        post.userDisplayName ?? 'Desconhecido',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Conteúdo
                  if (post.content != null && post.content!.isNotEmpty)
                    Text(
                      post.content!,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 8),
                  
                  // Data e ações
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (post.createdAt != null)
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              formatDate(post.createdAt!),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Botão de compartilhar
                          IconButton(
                            icon: const Icon(Icons.share, size: 20),
                            onPressed: _sharePost,
                            tooltip: 'Compartilhar',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 8),
                          // Botão de deletar
                          if (canDelete && onDelete != null)
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  size: 20, color: Colors.red),
                              onPressed: onDelete,
                              tooltip: 'Deletar',
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

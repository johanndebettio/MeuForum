import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Helper para gerenciar o salvamento e carregamento de imagens do app
class ImageStorageHelper {
  /// Salva uma imagem no diretório de documentos do app
  /// Retorna o caminho da imagem salva
  static Future<String> saveImage(File imageFile, {String? customName}) async {
    try {
      // Obtém o diretório de documentos do app
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${appDir.path}/images');
      
      // Cria o diretório se não existir
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      // Gera um nome único para a imagem
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = path.extension(imageFile.path);
      final fileName = customName ?? 'img_$timestamp$extension';
      
      // Caminho completo da nova imagem
      final savedImagePath = '${imagesDir.path}/$fileName';
      
      // Copia a imagem para o diretório do app
      final savedImage = await imageFile.copy(savedImagePath);
      
      return savedImage.path;
    } catch (e) {
      throw Exception('Erro ao salvar imagem: $e');
    }
  }

  /// Deleta uma imagem do sistema de arquivos
  static Future<bool> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Verifica se uma imagem existe
  static Future<bool> imageExists(String imagePath) async {
    try {
      final file = File(imagePath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// Obtém o File de uma imagem pelo caminho
  static File? getImageFile(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;
    final file = File(imagePath);
    return file;
  }

  /// Limpa todas as imagens não utilizadas (útil para manutenção)
  static Future<void> cleanUnusedImages(List<String> usedImagePaths) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${appDir.path}/images');
      
      if (!await imagesDir.exists()) return;

      final allFiles = await imagesDir.list().toList();
      
      for (var entity in allFiles) {
        if (entity is File) {
          if (!usedImagePaths.contains(entity.path)) {
            await entity.delete();
          }
        }
      }
    } catch (e) {
      // Silenciosamente ignora erros de limpeza
    }
  }
}

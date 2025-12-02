import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

/// Modelo para representar um GIF do GIPHY
class TenorGif {
  final String id;
  final String title;
  final String url; // URL do GIF
  final String previewUrl; // URL do preview (miniatura)

  TenorGif({
    required this.id,
    required this.title,
    required this.url,
    required this.previewUrl,
  });

  factory TenorGif.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as Map<String, dynamic>;
    final original = images['original'] as Map<String, dynamic>?;
    final preview = images['preview_gif'] as Map<String, dynamic>?;
    final fixedWidth = images['fixed_width'] as Map<String, dynamic>?;

    return TenorGif(
      id: json['id'] as String,
      title: json['title'] as String? ?? 'GIF',
      url: original?['url'] as String? ?? fixedWidth?['url'] as String? ?? '',
      previewUrl: preview?['url'] as String? ?? fixedWidth?['url'] as String? ?? '',
    );
  }
}

/// Serviço para buscar GIFs do GIPHY
class TenorService {
  /// Busca GIFs com base em uma query
  /// 
  /// [query] - Termo de busca (ex: "feliz", "triste", "engraçado")
  /// [limit] - Número de resultados (padrão: 20)
  static Future<List<TenorGif>> searchGifs(String query, {int limit = 20}) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final url = Uri.parse(
        '${ApiConfig.giphyBaseUrl}/search?'
        'q=$encodedQuery&'
        'api_key=${ApiConfig.giphyApiKey}&'
        'limit=$limit&'
        'rating=g&'
        'lang=pt',
      );

      print('Buscando GIFs: $url');
      final response = await http.get(url);
      print('Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['data'] as List;
        return results.map((json) => TenorGif.fromJson(json)).toList();
      } else {
        print('Erro: ${response.body}');
        throw Exception('Erro ao buscar GIFs: ${response.statusCode}');
      }
    } catch (e) {
      print('Exceção: $e');
      throw Exception('Erro ao buscar GIFs: $e');
    }
  }

  /// Busca GIFs em destaque (trending)
  /// 
  /// [limit] - Número de resultados (padrão: 20)
  static Future<List<TenorGif>> getTrendingGifs({int limit = 20}) async {
    try {
      final url = Uri.parse(
        '${ApiConfig.giphyBaseUrl}/trending?'
        'api_key=${ApiConfig.giphyApiKey}&'
        'limit=$limit&'
        'rating=g',
      );

      print('Buscando GIFs em destaque');
      final response = await http.get(url);
      print('Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['data'] as List;
        return results.map((json) => TenorGif.fromJson(json)).toList();
      } else {
        print('Erro: ${response.body}');
        throw Exception('Erro ao buscar GIFs em destaque: ${response.statusCode}');
      }
    } catch (e) {
      print('Exceção: $e');
      throw Exception('Erro ao buscar GIFs em destaque: $e');
    }
  }

  /// Categorias sugeridas para busca rápida
  static List<String> get suggestedCategories => [
        'feliz',
        'triste',
        'engraçado',
        'amor',
        'raiva',
        'surpreso',
        'comemorando',
        'pensando',
        'confuso',
        'legal',
      ];
}

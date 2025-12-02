import 'package:flutter/material.dart';
import '../services/giphy_service.dart';

/// Widget para selecionar GIFs do GIPHY
class GifPickerDialog extends StatefulWidget {
  const GifPickerDialog({super.key});

  @override
  State<GifPickerDialog> createState() => _GifPickerDialogState();
}

class _GifPickerDialogState extends State<GifPickerDialog> {
  final _searchController = TextEditingController();
  List<GiphyGif> _gifs = [];
  bool _loading = false;
  bool _showingTrending = true;

  @override
  void initState() {
    super.initState();
    _loadTrendingGifs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTrendingGifs() async {
    setState(() => _loading = true);
    try {
      final gifs = await GiphyService.getTrendingGifs(limit: 30);
      setState(() {
        _gifs = gifs;
        _showingTrending = true;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar GIFs: $e')),
        );
      }
    }
  }

  Future<void> _searchGifs(String query) async {
    if (query.trim().isEmpty) {
      _loadTrendingGifs();
      return;
    }

    setState(() => _loading = true);
    try {
      final gifs = await GiphyService.searchGifs(query, limit: 30);
      setState(() {
        _gifs = gifs;
        _showingTrending = false;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao buscar GIFs: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    _showingTrending ? 'GIFs em Destaque' : 'Buscar GIFs',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Search bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar GIFs...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _loadTrendingGifs();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: _searchGifs,
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 12),

            // Categorias sugeridas
            if (_showingTrending)
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: GiphyService.suggestedCategories.length,
                  itemBuilder: (context, index) {
                    final category = GiphyService.suggestedCategories[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(category),
                        onPressed: () {
                          _searchController.text = category;
                          _searchGifs(category);
                        },
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 12),

            // Grid de GIFs
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _gifs.isEmpty
                      ? const Center(child: Text('Nenhum GIF encontrado'))
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1,
                          ),
                          itemCount: _gifs.length,
                          itemBuilder: (context, index) {
                            final gif = _gifs[index];
                            return GestureDetector(
                              onTap: () => Navigator.pop(context, gif),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  gif.previewUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.error),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Função auxiliar para abrir o seletor de GIFs
Future<GiphyGif?> showGifPicker(BuildContext context) async {
  return await showDialog<GiphyGif>(
    context: context,
    builder: (context) => const GifPickerDialog(),
  );
}

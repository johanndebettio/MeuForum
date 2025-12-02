import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/image_picker_helper.dart';
import '../utils/image_storage_helper.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _imagePickerHelper = ImagePickerHelper();
  bool _isUpdating = false;

  Future<void> _updateProfileImage() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final userProvider = context.read<UserProvider>();
    
    final image = await _imagePickerHelper.pickImageWithDialog(context);
    if (image == null) return;

    if (!mounted) return;

    setState(() => _isUpdating = true);

    final error = await userProvider.updateProfileImage(image);

    setState(() => _isUpdating = false);

    if (!mounted) return;

    if (error == null) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Foto de perfil atualizada!')),
      );
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user ?? widget.user;
    final imageFile = ImageStorageHelper.getImageFile(user.profileImagePath);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Foto de perfil
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: imageFile != null && imageFile.existsSync()
                        ? FileImage(imageFile)
                        : null,
                    child: imageFile == null || !imageFile.existsSync()
                        ? Icon(Icons.person, size: 80, color: Colors.grey[600])
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        onPressed: _isUpdating ? null : _updateProfileImage,
                      ),
                    ),
                  ),
                  if (_isUpdating)
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Informações do usuário
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informações',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    _buildInfoRow(
                      icon: Icons.person,
                      label: 'Nome',
                      value: user.displayName ?? 'Não informado',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.alternate_email,
                      label: 'Usuário',
                      value: user.username,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.calendar_today,
                      label: 'Membro desde',
                      value: _formatDate(user.createdAt ?? ''),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(String isoDate) {
    final date = DateTime.tryParse(isoDate);
    if (date == null) return 'Não informado';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

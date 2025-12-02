import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Aparência',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Column(
                children: [
                  ListTile(
                    title: const Text('Tema Claro'),
                    subtitle: const Text('Sempre usar tema claro'),
                    leading: const Icon(Icons.light_mode),
                    trailing: Radio<ThemeMode>(
                      value: ThemeMode.light,
                      groupValue: themeProvider.themeMode,
                      onChanged: (ThemeMode? value) {
                        if (value != null) {
                          themeProvider.setThemeMode(value);
                        }
                      },
                    ),
                    onTap: () => themeProvider.setThemeMode(ThemeMode.light),
                  ),
                  ListTile(
                    title: const Text('Tema Escuro'),
                    subtitle: const Text('Sempre usar tema escuro'),
                    leading: const Icon(Icons.dark_mode),
                    trailing: Radio<ThemeMode>(
                      value: ThemeMode.dark,
                      groupValue: themeProvider.themeMode,
                      onChanged: (ThemeMode? value) {
                        if (value != null) {
                          themeProvider.setThemeMode(value);
                        }
                      },
                    ),
                    onTap: () => themeProvider.setThemeMode(ThemeMode.dark),
                  ),
                  ListTile(
                    title: const Text('Sistema'),
                    subtitle: const Text('Seguir configuração do sistema'),
                    leading: const Icon(Icons.brightness_auto),
                    trailing: Radio<ThemeMode>(
                      value: ThemeMode.system,
                      groupValue: themeProvider.themeMode,
                      onChanged: (ThemeMode? value) {
                        if (value != null) {
                          themeProvider.setThemeMode(value);
                        }
                      },
                    ),
                    onTap: () => themeProvider.setThemeMode(ThemeMode.system),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

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
                  RadioListTile<ThemeMode>(
                    title: const Text('Tema Claro'),
                    subtitle: const Text('Sempre usar tema claro'),
                    value: ThemeMode.light,
                    groupValue: themeProvider.themeMode,
                    onChanged: (ThemeMode? value) {
                      if (value != null) {
                        themeProvider.setThemeMode(value);
                      }
                    },
                    secondary: const Icon(Icons.light_mode),
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Tema Escuro'),
                    subtitle: const Text('Sempre usar tema escuro'),
                    value: ThemeMode.dark,
                    groupValue: themeProvider.themeMode,
                    onChanged: (ThemeMode? value) {
                      if (value != null) {
                        themeProvider.setThemeMode(value);
                      }
                    },
                    secondary: const Icon(Icons.dark_mode),
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Sistema'),
                    subtitle: const Text('Seguir configuração do sistema'),
                    value: ThemeMode.system,
                    groupValue: themeProvider.themeMode,
                    onChanged: (ThemeMode? value) {
                      if (value != null) {
                        themeProvider.setThemeMode(value);
                      }
                    },
                    secondary: const Icon(Icons.brightness_auto),
                  ),
                ],
              );
            },
          ),
          const Divider(height: 32),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Sobre',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Versão'),
            subtitle: const Text('1.0.0'),
          ),
        ],
      ),
    );
  }
}

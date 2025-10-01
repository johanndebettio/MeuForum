import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MeuForumApp());
}

class MeuForumApp extends StatelessWidget {
  const MeuForumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider()..loadSession(),
      child: Consumer<UserProvider>(
        builder: (_, userProvider, __) {
          return MaterialApp(
            title: 'Meu Fórum',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.light,
              useMaterial3: true,
            ),
            home: userProvider.isLoggedIn
                ? HomePage(user: userProvider.user!)
                : const LoginPage(),
          );
        },
      ),
    );
  }
}

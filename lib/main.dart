import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'providers/user_provider.dart';
import 'providers/post_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MeuForumApp());
}

class MeuForumApp extends StatelessWidget {
  const MeuForumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
      ],
      child: MaterialApp(
        title: 'Meu Fórum',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
          useMaterial3: true,
        ),
        home: const AppLoader(),
      ),
    );
  }
}

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);

    return FutureBuilder(
      future: Future(() async {
        await userProvider.loadSession();
        await postProvider.loadPosts();
        await Future.delayed(const Duration(milliseconds: 800));
      }),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (userProvider.isLoggedIn && userProvider.user != null) {
          return HomePage(user: userProvider.user!);
        } else {
          return const LoginPage();
        }
      },
    );
  }
}

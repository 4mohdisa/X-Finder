import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/pages/search_page.dart';
import 'src/provider/search_provider.dart';
import 'src/pages/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SearchProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'MyApp',
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const SplashPage(),
          '/search': (context) => const SearchScreen(),
        },
      ),
    );
  }
}

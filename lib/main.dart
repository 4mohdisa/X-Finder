import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sherlock/src/pages/search_page.dart';
import 'package:sherlock/src/provider/search_provider.dart';

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

// class WelcomeScreen extends StatelessWidget {
//   const WelcomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Your logo
//             SvgPicture.asset(
//               'assets/x_logo.svg',
//               width: 350, // Adjust the width as needed
//               height: 350, // Adjust the height as needed
//             ),

//             const SizedBox(height: 40),
//             // Button to go to the search screen
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
//               ),
//               onPressed: () {
//                 // Navigate to the search screen
//                 Navigator.pushNamed(context, '/search');
//               },
//               child: const Text(
//                 'Search',
//                 style: TextStyle(fontSize: 25, color: Colors.black),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

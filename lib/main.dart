import 'dart:io';

import 'package:cashier_app/Provider/provider_db.dart';
import 'package:cashier_app/View/splash_screens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:cashier_app/Provider/provider_db.dart';
import 'package:cashier_app/View/splash_screens.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Enable the sqflite FFI implementation when running on desktop.
//   if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
//     sqfliteFfiInit();
//     databaseFactory = databaseFactoryFfi;
//   }

//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (BuildContext context) => ProviderDB()..init(),
//       child: const MaterialApp(
//           debugShowCheckedModeBanner: false,
//           // home: ProductView(),
//           home: SplashScreen(), // use intro screen
//         )
//     );
//   }
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProviderDB()..init(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
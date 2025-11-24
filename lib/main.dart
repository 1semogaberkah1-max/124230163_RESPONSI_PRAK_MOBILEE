/* =============================================================================
[PANDUAN STRATEGI UJIAN]
KAPAN FILE INI DIEDIT?
1. Untuk mengganti Judul Aplikasi (Title).
2. Untuk mengganti Warna Tema Utama (Primary Swatch).
=============================================================================
*/

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'amiibo_model.dart';
import 'main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(AmiiboModelAdapter());
  await Hive.openBox<AmiiboModel>('favoritesBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // [UBAH DISINI]: Judul Aplikasi
      title: 'Responsi Amiibo App',
      theme: ThemeData(
        useMaterial3: true,
        // [UBAH DISINI]: Warna Tema (Colors.red, Colors.green, dll)
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}

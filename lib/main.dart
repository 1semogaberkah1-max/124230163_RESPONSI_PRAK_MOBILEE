import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'login_screen.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup Hive (Local Database) [cite: 41]
  await Hive.initFlutter();
  await Hive.openBox('sessionBox'); // Box untuk menyimpan status Login

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Cek Status Login
    var sessionBox = Hive.box('sessionBox');
    bool isLoggedIn = sessionBox.get('isLoggedIn') ?? false;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Responsi Meal App',
      theme: ThemeData(
        useMaterial3: true,
        // Tema warna Orange sesuai gambar soal
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      // Jika sudah login -> Home, Jika belum -> Login [cite: 40]
      home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}

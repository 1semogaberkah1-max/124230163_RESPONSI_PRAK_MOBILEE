import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart'; // Wajib install library ini
import 'models.dart';

class DetailScreen extends StatelessWidget {
  final String mealId;

  const DetailScreen({super.key, required this.mealId});

  Future<DetailModel> fetchDetail() async {
    final String url =
        "https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealId";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      // API MealDB mengembalikan list berisi 1 item
      return DetailModel.fromJson(data['meals'][0]);
    } else {
      throw Exception('Failed to load detail');
    }
  }

  // Helper fungsi untuk buka YouTube
  Future<void> _launchYoutube(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('ruwet gabisa eror aduh $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("detail makanan")),
      body: FutureBuilder<DetailModel>(
        future: fetchDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text("Error: ${snapshot.error}"));

          final meal = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Gambar Banner
                Image.network(meal.thumb, height: 250, fit: BoxFit.cover),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul & Info
                      Center(
                        child: Text(meal.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange)),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Chip(label: Text("Category: ${meal.category}")),
                          Chip(label: Text("Area: ${meal.area}")),
                        ],
                      ),
                      const Divider(thickness: 1.5),

                      // Ingredients (Bahan-bahan)
                      const Text("Ingredients",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      // Kita gunakan operator spread (...) untuk menampilkan List widget
                      ...meal.ingredients.map((e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text("• $e",
                                style: const TextStyle(fontSize: 16)),
                          )),

                      const SizedBox(height: 20),

                      // Instructions (Instruksi)
                      const Text("Instructions",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(meal.instructions,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify),

                      const SizedBox(height: 30),

                      // Tombol Video
                      SizedBox(
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (meal.youtubeUrl.isNotEmpty) {
                              _launchYoutube(meal.youtubeUrl);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("No Video Available")));
                            }
                          },
                          icon: const Icon(Icons.play_circle_fill,
                              color: Colors.white),
                          label: const Text("Watch Tutorial",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

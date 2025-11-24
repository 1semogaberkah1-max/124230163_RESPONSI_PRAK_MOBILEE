/* =============================================================================
[PANDUAN STRATEGI UJIAN]
KAPAN FILE INI DIEDIT?
1. Saat ingin memasukkan Link API (URL) dari soal.
2. Saat aplikasi error "Null check operator used on a null value" (Parsing JSON salah).
3. Saat ingin mengubah tampilan daftar di halaman depan (ListTile).
4. Saat logika ID Unik untuk Favorite berbeda (misal pakai ID angka, bukan head+tail).
=============================================================================
*/

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'amiibo_model.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // [UBAH DISINI]: Paste Link "Get All Data" dari Soal
  final String apiUrl = "https://www.amiiboapi.com/api/amiibo";

  late Box<AmiiboModel> favoriteBox;

  @override
  void initState() {
    super.initState();
    favoriteBox = Hive.box<AmiiboModel>('favoritesBox');
  }

  Future<List<AmiiboModel>> fetchData() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      // [UBAH DISINI]: LOGIKA PARSING JSON
      // Cek Browser. Data list ada di dalam kunci apa? 'amiibo'? 'results'? 'data'?
      final List<dynamic> amiiboList = data['amiibo'];

      return amiiboList.map((json) => AmiiboModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // [UBAH DISINI]: Judul Halaman Depan
      appBar: AppBar(title: const Text("Nintendo Amiibo List")),

      body: FutureBuilder<List<AmiiboModel>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No Data Found"));
          }

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];

              return ValueListenableBuilder(
                valueListenable: favoriteBox.listenable(),
                builder: (context, Box<AmiiboModel> box, _) {
                  // [UBAH DISINI]: LOGIKA ID UNIK FAVORITE
                  // Sesuaikan dengan ID unik di Model (bisa 'id', bisa 'head'+'tail', dll)
                  final isFavorite = box.values
                      .any((e) => e.head == item.head && e.tail == item.tail);

                  return Card(
                    child: ListTile(
                      // [UBAH DISINI]: TAMPILAN LIST ITEM
                      leading: Image.network(item.image,
                          width: 50,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.error)),
                      title: Text(item.character),
                      subtitle: Text(item.gameSeries),

                      trailing: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : null,
                        ),
                        onPressed: () {
                          if (isFavorite) {
                            // LOGIKA DELETE (Cari Key berdasarkan ID Unik)
                            final key = box.keys.firstWhere((k) {
                              final val = box.get(k);
                              return val?.head == item.head &&
                                  val?.tail == item.tail;
                            }, orElse: () => null);
                            if (key != null) box.delete(key);
                          } else {
                            // LOGIKA ADD
                            box.add(item);
                          }
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailScreen(amiibo: item)),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

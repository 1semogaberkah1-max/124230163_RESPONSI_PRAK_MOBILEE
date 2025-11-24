/* =============================================================================
[PANDUAN STRATEGI UJIAN]
KAPAN FILE INI DIEDIT?
1. Saat ingin menampilkan informasi lengkap dari API.
2. Saat nama variabel di Model berubah (misal 'character' jadi 'judul').
3. Saat ingin mengatur tata letak (Layout) halaman detail.
=============================================================================
*/

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'amiibo_model.dart';

class DetailScreen extends StatelessWidget {
  final AmiiboModel amiibo;

  const DetailScreen({super.key, required this.amiibo});

  @override
  Widget build(BuildContext context) {
    var favoriteBox = Hive.box<AmiiboModel>('favoritesBox');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Amiibo Details"),
        actions: [
          // Logic Favorite (Biasanya sama persis dengan Home, tidak perlu diubah kecuali ID beda)
          ValueListenableBuilder(
            valueListenable: favoriteBox.listenable(),
            builder: (context, Box<AmiiboModel> box, _) {
              final isFavorite = box.values
                  .any((e) => e.head == amiibo.head && e.tail == amiibo.tail);
              return IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red),
                onPressed: () {
                  if (isFavorite) {
                    final key = box.keys.firstWhere((k) {
                      final val = box.get(k);
                      return val?.head == amiibo.head &&
                          val?.tail == amiibo.tail;
                    }, orElse: () => null);
                    if (key != null) box.delete(key);
                  } else {
                    box.add(amiibo);
                  }
                },
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // [UBAH DISINI]: GAMBAR BESAR
            Center(child: Image.network(amiibo.image, height: 250)),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // [UBAH DISINI]: DATA-DATA LENGKAP
                  Text("Character: ${amiibo.character}",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const Divider(),

                  Text("Game Series: ${amiibo.gameSeries}"),
                  Text("Amiibo Series: ${amiibo.amiiboSeries}"),
                  Text("Type: ${amiibo.type}"),

                  const SizedBox(height: 20),

                  // [UBAH DISINI]: DATA BERSARANG (NESTED)
                  // Hapus blok ini jika soal tidak pakai nested object
                  const Text("Release Dates",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Divider(),
                  _buildReleaseRow("Australia", amiibo.releaseAu),
                  _buildReleaseRow("Europe", amiibo.releaseEu),
                  _buildReleaseRow("Japan", amiibo.releaseJp),
                  _buildReleaseRow("North America", amiibo.releaseNa),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReleaseRow(String region, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(region, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(date),
        ],
      ),
    );
  }
}

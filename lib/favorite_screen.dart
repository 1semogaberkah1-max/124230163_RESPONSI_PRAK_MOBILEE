/* =============================================================================
[PANDUAN STRATEGI UJIAN]
KAPAN FILE INI DIEDIT?
1. Agar tampilan item favorite SAMA dengan tampilan item di Home.
2. Tidak banyak logika di sini, cukup copy-paste tampilan 'ListTile' dari Home.
=============================================================================
*/

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'amiibo_model.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteBox = Hive.box<AmiiboModel>('favoritesBox');

    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: ValueListenableBuilder(
        valueListenable: favoriteBox.listenable(),
        builder: (context, Box<AmiiboModel> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text("No Favorites Yet"));
          }

          final List<dynamic> keys = box.keys.toList();

          return ListView.builder(
            itemCount: keys.length,
            itemBuilder: (context, index) {
              final key = keys[index];
              final AmiiboModel? item = box.get(key);

              if (item == null) return const SizedBox.shrink();

              return Dismissible(
                key: Key(key.toString()),
                background: Container(color: Colors.red),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  box.delete(key);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${item.character} removed')),
                  );
                },
                child: Card(
                  child: ListTile(
                    // [UBAH DISINI]: SAMAKAN DENGAN HOME SCREEN
                    // Copy bagian ini dari home_screen.dart agar konsisten
                    leading: Image.network(item.image, width: 50),
                    title: Text(item.character),
                    subtitle: Text(item.amiiboSeries),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

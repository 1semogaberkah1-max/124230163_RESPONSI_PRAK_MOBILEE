/* =============================================================================
[PANDUAN STRATEGI UJIAN]
KAPAN FILE INI DIEDIT?
1. Saat pertama kali membaca soal dan melihat Link API.
2. Saat JSON di browser memiliki nama key yang berbeda (misal 'name' jadi 'title').
3. Saat ada data baru yang perlu ditampilkan (misal 'harga', 'deskripsi').
4. Saat ada data bersarang (nested object) seperti 'release date'.

APA YANG HARUS DILAKUKAN SETELAH EDIT?
Wajib jalankan terminal: dart run build_runner build --delete-conflicting-outputs
=============================================================================
*/

import 'package:hive/hive.dart';

// [PERHATIKAN] Nama file ini WAJIB sama dengan nama file .dart kamu.
part 'amiibo_model.g.dart';

@HiveType(typeId: 0)
class AmiiboModel extends HiveObject {
  // -----------------------------------------------------------
  // [UBAH DISINI]: DEFINISI VARIABEL
  // Sesuaikan nama variabel dengan JSON di Browser!
  // Urutkan @HiveField dari 0, 1, 2, dst.
  // -----------------------------------------------------------

  @HiveField(0)
  final String amiiboSeries; // Contoh: ganti jadi 'kategori'

  @HiveField(1)
  final String character; // Contoh: ganti jadi 'judul'

  @HiveField(2)
  final String gameSeries; // Contoh: ganti jadi 'deskripsi'

  @HiveField(3)
  final String head; // ID Unik 1

  @HiveField(4)
  final String tail; // ID Unik 2

  @HiveField(5)
  final String image; // URL Gambar (biasanya 'image', 'url', 'poster')

  @HiveField(6)
  final String type;

  // -----------------------------------------------------------
  // [KASUS KHUSUS]: DATA BERSARANG (NESTED OBJECT)
  // Jika JSON datar semua, hapus bagian di bawah ini.
  // -----------------------------------------------------------
  @HiveField(7)
  final String releaseAu;
  @HiveField(8)
  final String releaseEu;
  @HiveField(9)
  final String releaseJp;
  @HiveField(10)
  final String releaseNa;

  AmiiboModel({
    required this.amiiboSeries,
    required this.character,
    required this.gameSeries,
    required this.head,
    required this.tail,
    required this.image,
    required this.type,
    required this.releaseAu,
    required this.releaseEu,
    required this.releaseJp,
    required this.releaseNa,
  });

  // -----------------------------------------------------------
  // [UBAH DISINI]: MAPPING JSON (KIRI = KODINGAN, KANAN = API)
  // Pastikan json['KEY'] sama persis huruf besar/kecilnya dengan Browser.
  // -----------------------------------------------------------
  factory AmiiboModel.fromJson(Map<String, dynamic> json) {
    // [LOGIKA DATA BERSARANG]
    // Jika tidak ada data bersarang, hapus baris ini.
    final releaseBox = json['release'] ?? {};

    return AmiiboModel(
      amiiboSeries: json['amiiboSeries'] ?? 'Unknown',
      character: json['character'] ?? 'Unknown',
      gameSeries: json['gameSeries'] ?? 'Unknown',
      head: json['head'] ?? '',
      tail: json['tail'] ?? '',
      image: json['image'] ?? '',
      type: json['type'] ?? 'Unknown',

      // Flattening data bersarang
      releaseAu: releaseBox['au'] ?? '-',
      releaseEu: releaseBox['eu'] ?? '-',
      releaseJp: releaseBox['jp'] ?? '-',
      releaseNa: releaseBox['na'] ?? '-',
    );
  }
}

/* =============================================================================
[MODEL DATA MEAL APP]
File ini menangani 3 struktur JSON dari API TheMealDB:
1. CategoryModel: Untuk data Kategori (Halaman Home).
2. MealModel: Untuk data List Makanan (Halaman Grid).
3. DetailModel: Untuk data Detail Lengkap (Termasuk Ingredients yang ribet).
=============================================================================
*/

class CategoryModel {
  final String id;
  final String name;
  final String thumb;
  final String description;

  CategoryModel(
      {required this.id,
      required this.name,
      required this.thumb,
      required this.description});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['idCategory'],
      name: json['strCategory'],
      thumb: json['strCategoryThumb'],
      description: json['strCategoryDescription'],
    );
  }
}

class MealModel {
  final String id;
  final String name;
  final String thumb;

  MealModel({required this.id, required this.name, required this.thumb});

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['idMeal'],
      name: json['strMeal'],
      thumb: json['strMealThumb'],
    );
  }
}

class DetailModel {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumb;
  final String youtubeUrl;
  final List<String> ingredients; // Kita jadikan List biar gampang ditampilkan

  DetailModel({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumb,
    required this.youtubeUrl,
    required this.ingredients,
  });

  factory DetailModel.fromJson(Map<String, dynamic> json) {
    // [TRIK KHUSUS API THEMEALDB]
    // Bahan makanan dipisah jadi strIngredient1 s/d strIngredient20.
    // Kita loop manual untuk menggabungkannya jadi satu List rapi.
    List<String> ingredientsList = [];
    for (int i = 1; i <= 20; i++) {
      String? ingredient = json['strIngredient$i'];
      String? measure = json['strMeasure$i'];

      // Ambil hanya yang ada isinya (tidak null/kosong)
      if (ingredient != null && ingredient.trim().isNotEmpty) {
        ingredientsList.add("$ingredient ($measure)");
      }
    }

    return DetailModel(
      id: json['idMeal'],
      name: json['strMeal'],
      category: json['strCategory'],
      area: json['strArea'],
      instructions: json['strInstructions'],
      thumb: json['strMealThumb'],
      youtubeUrl: json['strYoutube'] ?? '',
      ingredients: ingredientsList,
    );
  }
}

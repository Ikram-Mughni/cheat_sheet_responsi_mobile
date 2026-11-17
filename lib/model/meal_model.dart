class MealModel {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumb;

  MealModel({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumb,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['idMeal']?.toString() ?? '',
      name: json['strMeal']?.toString() ?? 'Tanpa Nama',
      category: json['strCategory']?.toString() ?? 'Umum',
      area: json['strArea']?.toString() ?? 'Internasional',
      instructions: json['strInstructions']?.toString() ?? 'Tidak ada instruksi khusus.',
      thumb: json['strMealThumb']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMeal': id,
      'strMeal': name,
      'strCategory': category,
      'strArea': area,
      'strInstructions': instructions,
      'strMealThumb': thumb,
    };
  }
}

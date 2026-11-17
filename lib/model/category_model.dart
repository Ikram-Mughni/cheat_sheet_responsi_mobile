class CategoryModel {
  final String id;
  final String name;
  final String thumb;
  final String description;

  CategoryModel({
    required this.id,
    required this.name,
    required this.thumb,
    required this.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['idCategory']?.toString() ?? '',
      name: json['strCategory']?.toString() ?? '',
      thumb: json['strCategoryThumb']?.toString() ?? '',
      description: json['strCategoryDescription']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCategory': id,
      'strCategory': name,
      'strCategoryThumb': thumb,
      'strCategoryDescription': description,
    };
  }
}

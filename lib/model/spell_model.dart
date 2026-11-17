class SpellModel {
  // TERUBAH: Menyesuaikan properti model data sekunder untuk Mantra Sihir (Spells)
  final String id; // TERUBAH: ID mantra
  final String name; // TERUBAH: Nama mantra
  final String description; // TERUBAH: Deskripsi fungsi mantra sihir

  SpellModel({
    required this.id,
    required this.name,
    required this.description,
  });

  // TERUBAH: Mapping JSON sesuai endpoint /spells dari HP-API
  factory SpellModel.fromJson(Map<String, dynamic> json) {
    return SpellModel(
      id: json['id']?.toString() ?? '', // TERUBAH: Mapping id mantra
      name: json['name']?.toString() ?? 'Unknown Spell', // TERUBAH: Mapping name mantra
      description: json['description']?.toString() ?? 'No description available', // TERUBAH: Mapping description mantra
    );
  }

  // TERUBAH: Serialisasi JSON untuk SpellModel
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}

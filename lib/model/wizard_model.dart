class WizardModel {
  // TERUBAH: Mengganti tipe data id dari int menjadi String (UUID dari HP-API)
  final String id;
  // TERUBAH: Menyesuaikan nama variabel nama karakter
  final String name;
  // TERUBAH: Mengganti status menjadi house (asrama Hogwarts)
  final String house;
  // TERUBAH: Menyesuaikan properti spesies karakter
  final String species;
  // TERUBAH: Mengganti gender/origin menjadi nama aktor pemeran
  final String actor;
  // TERUBAH: Menambahkan properti patronus sihir
  final String patronus;
  // TERUBAH: Mengganti location menjadi tanggal lahir (dateOfBirth)
  final String dateOfBirth;
  // TERUBAH: Menambahkan boolean status hidup (alive)
  final bool alive;
  // TERUBAH: Properti URL foto karakter dari HP-API
  final String image;

  WizardModel({
    required this.id,
    required this.name,
    required this.house,
    required this.species,
    required this.actor,
    required this.patronus,
    required this.dateOfBirth,
    required this.alive,
    required this.image,
  });

  // TERUBAH: Pemetaan fromJson disesuaikan dengan key dari HP-API dan diberikan null-safety fallback
  factory WizardModel.fromJson(Map<String, dynamic> json) {
    return WizardModel(
      id: json['id']?.toString() ?? '', // TERUBAH: Mapping key 'id' string UUID
      name: json['name']?.toString() ?? 'Unknown Wizard', // TERUBAH: Mapping key 'name'
      house: (json['house'] != null && json['house'].toString().isNotEmpty)
          ? json['house'].toString()
          : 'No House', // TERUBAH: Mapping key 'house' dengan fallback 'No House'
      species: json['species']?.toString() ?? 'Human', // TERUBAH: Mapping key 'species'
      actor: (json['actor'] != null && json['actor'].toString().isNotEmpty)
          ? json['actor'].toString()
          : 'Unknown Actor', // TERUBAH: Mapping key 'actor'
      patronus: (json['patronus'] != null && json['patronus'].toString().isNotEmpty)
          ? json['patronus'].toString()
          : 'None', // TERUBAH: Mapping key 'patronus'
      dateOfBirth: json['dateOfBirth']?.toString() ?? '-', // TERUBAH: Mapping key 'dateOfBirth'
      alive: json['alive'] ?? true, // TERUBAH: Mapping boolean key 'alive'
      image: json['image']?.toString() ?? '', // TERUBAH: Mapping key 'image' URL foto
    );
  }

  // TERUBAH: Menyesuaikan serialisasi toJson untuk penyimpanan SharedPreferences favorit
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'house': house,
      'species': species,
      'actor': actor,
      'patronus': patronus,
      'dateOfBirth': dateOfBirth,
      'alive': alive,
      'image': image,
    };
  }
}

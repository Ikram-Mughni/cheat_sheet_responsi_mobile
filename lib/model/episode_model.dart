class EpisodeModel {
  // TODO (RESPONSI): Sesuaikan tipe data dan nama variabel untuk data sekunder (misal: Reviews, Episodes, Chapters).
  final int id;
  final String name;
  final String airDate;
  final String episodeCode;

  EpisodeModel({
    required this.id,
    required this.name,
    required this.airDate,
    required this.episodeCode,
  });

  // TODO (RESPONSI): Ganti key ['...'] sesuai dengan key JSON dari API data sekunder.
  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] ?? 'Unknown Episode',
      airDate: json['air_date'] ?? '-',
      episodeCode: json['episode'] ?? '-',
    );
  }
}

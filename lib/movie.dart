class Movie {
  final int id;
  final String title;
  final String imageUrl;
  final String releaseDate;
  final String runtime;
  final String? overview;

  Movie({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.releaseDate,
    required this.runtime,
    this.overview,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? json['name'] ?? 'Sans titre',
      imageUrl: 'https://image.tmdb.org/t/p/original${json["poster_path"]}',
      releaseDate: json['release_date'] ?? json['first_air_date'] ?? 'Inconnue',
      runtime: '${json["runtime"]?.toString() ?? "Durée inconnue"} min',
      overview: json['overview'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'releaseDate': releaseDate,
      'runtime': runtime,
      'overview': overview,
    };
  }
}

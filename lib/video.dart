class Video {
  final bool adult;
  final String backdrop_path;
  final List<int> genre_ids;
  final int id;
  final String original_language;
  final String original_title;
  final String overview;
  final double popularity;
  final String poster_path;
  final String release_date;
  final String title;
  final bool video;
  final double vote_average;
  final int vote_count;

  const Video(
      {required this.adult,
      required this.backdrop_path,
      required this.genre_ids,
      required this.id,
      required this.original_language,
      required this.original_title,
      required this.overview,
      required this.popularity,
      required this.poster_path,
      required this.release_date,
      required this.title,
      required this.video,
      required this.vote_average,
      required this.vote_count});

  factory Video.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'adult': bool adult,
        'backdrop_path': String backdrop_path,
        'genre_ids': List<int> genre_ids,
        'id': int id,
        'original_language': String original_language,
        'original_title': String original_title,
        'overview': String overview,
        'popularity': double popularity,
        'poster_path': String poster_path,
        'release_date': String release_date,
        'title': String title,
        'video': bool video,
        'vote_average': double vote_average,
        'vote_count': int vote_count
      } =>
        Video(
          adult: adult,
          backdrop_path: backdrop_path,
          genre_ids: genre_ids,
          id: id,
          original_language: original_language,
          original_title: original_title,
          overview: overview,
          popularity: popularity,
          poster_path: poster_path,
          release_date: release_date,
          title: title,
          video: video,
          vote_average: vote_average,
          vote_count: vote_count,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}

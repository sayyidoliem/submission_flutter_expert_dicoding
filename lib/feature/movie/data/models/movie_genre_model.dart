import 'package:ditonton/feature/movie/domain/entities/movie_genre.dart';
import 'package:equatable/equatable.dart';

class GenreModel extends Equatable {
  GenreModel.MovieGenreModel({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory GenreModel.fromJson(Map<String, dynamic> json) => GenreModel.MovieGenreModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  MovieGenre toEntity() {
    return MovieGenre(id: this.id, name: this.name);
  }

  @override
  List<Object?> get props => [id, name];
}

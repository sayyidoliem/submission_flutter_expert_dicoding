import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/feature/movie/domain/entities/movie_detail.dart';
import 'package:ditonton/feature/movie/domain/repositories/movie_repository.dart';

class SaveWatchlistMovies {
  final MovieRepository repository;

  SaveWatchlistMovies(this.repository);

  Future<Either<Failure, String>> execute(MovieDetail movie) {
    return repository.saveWatchlist(movie);
  }
}

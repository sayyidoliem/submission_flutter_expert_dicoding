import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/feature/tv/domain/entities/tv_detail.dart';
import 'package:ditonton/feature/tv/domain/repositories/tv_repository.dart';

class SaveWatchlistTvs {
  final TvRepository repository;

  SaveWatchlistTvs(this.repository);

  Future<Either<Failure, String>> execute(TvDetail movie) {
    return repository.saveWatchlist(movie);
  }
}
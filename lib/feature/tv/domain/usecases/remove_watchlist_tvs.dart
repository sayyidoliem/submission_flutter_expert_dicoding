import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/feature/tv/domain/entities/tv_detail.dart';
import 'package:ditonton/feature/tv/domain/repositories/tv_repository.dart';

class RemoveWatchlistTvs {
  final TvRepository repository;

  RemoveWatchlistTvs(this.repository);

  Future<Either<Failure, String>> execute(TvDetail tv) {
    return repository.removeWatchlist(tv);
  }
}
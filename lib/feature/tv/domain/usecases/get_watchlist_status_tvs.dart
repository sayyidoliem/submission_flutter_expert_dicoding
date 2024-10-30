import 'package:ditonton/feature/tv/domain/repositories/tv_repository.dart';

class GetWatchlistStatusTvs {
  final TvRepository repository;

  GetWatchlistStatusTvs(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}

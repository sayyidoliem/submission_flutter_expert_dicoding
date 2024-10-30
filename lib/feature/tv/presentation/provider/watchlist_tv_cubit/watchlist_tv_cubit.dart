import 'package:ditonton/feature/tv/domain/entities/tv.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_watchlist_tvs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'watchlist_tv_state.dart';

class WatchlistTvCubit extends Cubit<WatchlistTvState> {
  final GetWatchlistTvs getWatchlistTvs;

  WatchlistTvCubit({required this.getWatchlistTvs}) : super(WatchlistTvInitial());

  Future<void> fetchWatchlistTvs() async {
    emit(WatchlistTvLoading());

    final result = await getWatchlistTvs.execute();
    result.fold(
      (failure) {
        emit(WatchlistTvError(failure.message));
      },
      (tvsData) {
        emit(WatchlistTvLoaded(tvsData));
      },
    );
  }
}

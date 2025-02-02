import 'package:ditonton/feature/tv/domain/entities/tv.dart';
import 'package:ditonton/feature/tv/domain/entities/tv_detail.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_watchlist_status_tvs.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_watchlist_tvs.dart';
import 'package:ditonton/feature/tv/domain/usecases/remove_watchlist_tvs.dart';
import 'package:ditonton/feature/tv/domain/usecases/save_watchlist_tvs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'watchlist_tv_state.dart';

class WatchlistTvCubit extends Cubit<WatchlistTvState> {
  final GetWatchlistTvs getWatchlistTvs;
  final GetWatchlistStatusTvs getWatchListStatus;
  final SaveWatchlistTvs saveWatchlist;
  final RemoveWatchlistTvs removeWatchlist;

  WatchlistTvCubit({
    required this.getWatchlistTvs,
    required this.saveWatchlist,
    required this.removeWatchlist,
    required this.getWatchListStatus,
  }) : super(WatchlistTvInitial());

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

  Future<void> addWatchlist(TvDetail tv) async {
    final result = await saveWatchlist.execute(tv);
    String? message;

    result.fold(
      (failure) => message = failure.message,
      (successMessage) => message = successMessage,
    );

    await loadWatchlistStatus(tv.id ?? 0);
    emit(TvWatchlistStatusState(true, message ?? ''));
  }

  Future<void> removeFromWatchlist(TvDetail tv) async {
    final result = await removeWatchlist.execute(tv);
    String? message;

    result.fold(
      (failure) => message = failure.message,
      (successMessage) => message = successMessage,
    );

    await loadWatchlistStatus(tv.id ?? 0);
    emit(TvWatchlistStatusState(false, message ?? ''));
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    emit(TvWatchlistStatusState(result, ''));
  }
}

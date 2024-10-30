import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ditonton/feature/tv/domain/entities/tv.dart';
import 'package:ditonton/feature/tv/domain/entities/tv_detail.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_watchlist_status_tvs.dart';
import 'package:ditonton/feature/tv/domain/usecases/remove_watchlist_tvs.dart';
import 'package:ditonton/feature/tv/domain/usecases/save_watchlist_tvs.dart';

// Define states for TvDetailCubit
part 'tv_detail_state.dart';

class TvDetailCubit extends Cubit<TvDetailState> {
  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetWatchlistStatusTvs getWatchListStatus;
  final SaveWatchlistTvs saveWatchlist;
  final RemoveWatchlistTvs removeWatchlist;

  TvDetailCubit({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(TvDetailInitial());

  Future<void> fetchTvDetail(int id) async {
    emit(TvDetailLoading());

    final detailResult = await getTvDetail.execute(id);
    final recommendationResult = await getTvRecommendations.execute(id);
    final isAddedToWatchlistResult = await getWatchListStatus.execute(id);

    detailResult.fold(
      (failure) => emit(TvDetailError(failure.message)),
      (tv) {
        recommendationResult.fold(
          (failure) => emit(TvDetailLoaded(tv, [], isAddedToWatchlistResult)),
          (tvs) => emit(TvDetailLoaded(tv, tvs, isAddedToWatchlistResult)),
        );
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
    emit(TvDetailWatchlistUpdated(message ?? ''));
  }

  Future<void> removeFromWatchlist(TvDetail tv) async {
    final result = await removeWatchlist.execute(tv);
    String? message;

    result.fold(
      (failure) => message = failure.message,
      (successMessage) => message = successMessage,
    );

    await loadWatchlistStatus(tv.id ?? 0);
    emit(TvDetailWatchlistUpdated(message ?? ''));
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    emit(TvDetailWatchlistStatus(result, ''));
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ditonton/feature/tv/domain/entities/tv.dart';
import 'package:ditonton/feature/tv/domain/entities/tv_detail.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_watchlist_status_tvs.dart';

// Define states for TvDetailCubit
part 'tv_detail_state.dart';

class TvDetailCubit extends Cubit<TvDetailState> {
  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetWatchlistStatusTvs getWatchListStatus;

  TvDetailCubit({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getWatchListStatus,
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
}

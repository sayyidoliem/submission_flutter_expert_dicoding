import 'package:bloc/bloc.dart';
import 'package:ditonton/feature/tv/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_now_playing_tvs.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_popular_tvs.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_top_rated_tvs.dart';

part 'tv_list_state.dart';

class TvListCubit extends Cubit<TvListState> {
  final GetNowPlayingTvs getNowPlayingTvs;
  final GetPopularTvs getPopularTvs;
  final GetTopRatedTvs getTopRatedTvs;

  TvListCubit({
    required this.getNowPlayingTvs,
    required this.getPopularTvs,
    required this.getTopRatedTvs,
  }) : super(TvListInitial());

  Future<void> fetchNowPlayingTvs() async {
    emit(TvListLoading());

    final result = await getNowPlayingTvs.execute();
    result.fold(
      (failure) => emit(TvListError(failure.message)),
      (tvsData) => emit(NowPlayingTvsLoaded(tvsData)),
    );
  }

  Future<void> fetchPopularTvs() async {
    emit(TvListLoading());

    final result = await getPopularTvs.execute();
    result.fold(
      (failure) => emit(TvListError(failure.message)),
      (tvsData) => emit(PopularTvsLoaded(tvsData)),
    );
  }

  Future<void> fetchTopRatedTvs() async {
    emit(TvListLoading());

    final result = await getTopRatedTvs.execute();
    result.fold(
      (failure) => emit(TvListError(failure.message)),
      (tvsData) => emit(TopRatedTvsLoaded(tvsData)),
    );
  }
}

import 'package:bloc/bloc.dart';
import 'package:ditonton/feature/tv/domain/entities/tv.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_tvs_state.dart';

class TopRatedTvsCubit extends Cubit<TopRatedTvsState> {
  final GetTopRatedTvs getTopRatedTvs;

  TopRatedTvsCubit(this.getTopRatedTvs) : super(TopRatedTvsInitial());

  Future<void> fetchTopRatedTvs() async {
    emit(TopRatedTvsLoading());

    final result = await getTopRatedTvs.execute();

    result.fold(
      (failure) {
        emit(TopRatedTvsError(failure.message));
      },
      (tvsData) {
        emit(TopRatedTvsLoaded(tvsData));
      },
    );
  }
}
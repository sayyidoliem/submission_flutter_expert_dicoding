import 'package:bloc/bloc.dart';
import 'package:ditonton/feature/tv/domain/entities/tv.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_popular_tvs.dart';
import 'package:equatable/equatable.dart';

part 'popular_tvs_state.dart';

class PopularTvsCubit extends Cubit<PopularTvsState> {
  final GetPopularTvs getPopularTvs;

  PopularTvsCubit(this.getPopularTvs) : super(PopularTvsInitial());

  Future<void> fetchPopularTvs() async {
    emit(PopularTvsLoading());

    final result = await getPopularTvs.execute();

    result.fold(
      (failure) {
        emit(PopularTvsError(failure.message));
      },
      (tvsData) {
        emit(PopularTvsLoaded(tvsData));
      },
    );
  }
}
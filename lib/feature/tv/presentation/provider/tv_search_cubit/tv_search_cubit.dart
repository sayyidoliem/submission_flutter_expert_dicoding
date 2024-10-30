import 'package:ditonton/feature/tv/domain/entities/tv.dart';
import 'package:ditonton/feature/tv/domain/usecases/search_tvs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_search_state.dart';

class TvSearchCubit extends Cubit<TvSearchState> {
  final SearchTvs searchTvs;

  TvSearchCubit({required this.searchTvs}) : super(TvSearchInitial());

  Future<void> fetchTvSearch(String query) async {
    emit(TvSearchLoading());

    final result = await searchTvs.execute(query);
    result.fold(
      (failure) {
        emit(TvSearchError(failure.message));
      },
      (data) {
        emit(TvSearchLoaded(data));
      },
    );
  }
}

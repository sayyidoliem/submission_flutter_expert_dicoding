import 'package:ditonton/feature/movie/domain/entities/movie.dart';
import 'package:ditonton/feature/movie/domain/usecases/search_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'movie_search_state.dart';

class MovieSearchCubit extends Cubit<MovieSearchState> {
  final SearchMovies searchMovies;

  MovieSearchCubit({required this.searchMovies}) : super(MovieSearchInitial());

  Future<void> fetchMovieSearch(String query) async {
    emit(MovieSearchLoading());

    final result = await searchMovies.execute(query);
    result.fold(
      (failure) {
        emit(MovieSearchError(failure.message));
      },
      (data) {
        emit(MovieSearchLoaded(data));
      },
    );
  }
}

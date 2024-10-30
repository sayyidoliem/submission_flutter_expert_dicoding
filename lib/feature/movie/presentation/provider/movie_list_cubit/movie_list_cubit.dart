import 'package:bloc/bloc.dart';
import 'package:ditonton/feature/movie/domain/entities/movie.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';

part 'movie_list_state.dart';

class MovieListCubit extends Cubit<MovieListState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  MovieListCubit({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  }) : super(MovieListInitial());

  Future<void> fetchNowPlayingMovies() async {
    emit(MovieListLoading());
    
    final result = await getNowPlayingMovies.execute();
    result.fold(
      (failure) {
        emit(MovieListError(failure.message));
      },
      (moviesData) {
        emit(MovieListLoaded( moviesData));
      },
    );
  }

  Future<void> fetchPopularMovies() async {
    emit(MovieListLoading());

    final result = await getPopularMovies.execute();
    result.fold(
      (failure) {
        emit(MovieListError(failure.message));
      },
      (moviesData) {
        final currentState = state;
        if (currentState is MovieListLoaded) {
          emit(currentState.copyWith(popularMovies: moviesData));
        } else {
          emit(MovieListLoaded(moviesData));
        }
      },
    );
  }

  Future<void> fetchTopRatedMovies() async {
    emit(MovieListLoading());

    final result = await getTopRatedMovies.execute();
    result.fold(
      (failure) {
        emit(MovieListError(failure.message));
      },
      (moviesData) {
        final currentState = state;
        if (currentState is MovieListLoaded) {
          emit(currentState.copyWith(topRatedMovies: moviesData));
        } else {
          emit(MovieListLoaded( moviesData));
        }
      },
    );
  }
}

import 'package:bloc/bloc.dart';
import 'package:ditonton/feature/movie/domain/entities/movie.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_watchlist_movies.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_movie_state.dart';


class WatchlistMoviesCubit extends Cubit<WatchlistMoviesState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMoviesCubit({required this.getWatchlistMovies}) 
      : super(WatchlistMoviesInitial());

  Future<void> fetchWatchlistMovies() async {
    emit(WatchlistMoviesLoading());

    final result = await getWatchlistMovies.execute();
    result.fold(
      (failure) {
        emit(WatchlistMoviesError(failure.message));
      },
      (moviesData) {
        emit(WatchlistMoviesLoaded(moviesData));
      },
    );
  }
}
import 'package:bloc/bloc.dart';
import 'package:ditonton/feature/movie/domain/entities/movie.dart';
import 'package:ditonton/feature/movie/domain/entities/movie_detail.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_watchlist_status_movies.dart';
import 'package:ditonton/feature/movie/domain/usecases/remove_watchlist_movies.dart';
import 'package:ditonton/feature/movie/domain/usecases/save_watchlist_movies.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_movie_state.dart';

class WatchlistMoviesCubit extends Cubit<WatchlistMoviesState> {
  final GetWatchlistMovies getWatchlistMovies;
  final GetWatchListStatusMovies getWatchListStatus;
  final SaveWatchlistMovies saveWatchlist;
  final RemoveWatchlistMovies removeWatchlist;

  WatchlistMoviesCubit({
    required this.getWatchlistMovies,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(WatchlistMoviesInitial());

  Future<void> fetchWatchlistMovies() async {
    emit(WatchlistMoviesLoading()); // Emit loading state
    final result = await getWatchlistMovies.execute();

    result.fold(
      (failure) => emit(WatchlistMoviesError(failure.message)),
      (movies) => emit(WatchlistMoviesLoaded(movies)),
    );
  }

  Future<void> addWatchlist(MovieDetail movie) async {
    final result = await saveWatchlist.execute(movie);
    String? message;

    result.fold(
      (failure) => message = failure.message,
      (successMessage) => message = successMessage,
    );

    await loadWatchlistStatus(movie.id);
    emit(WatchlistStatusState(true, message ?? ''));
  }

  Future<void> removeFromWatchlist(MovieDetail movie) async {
    final result = await removeWatchlist.execute(movie);
    String? message;

    result.fold(
      (failure) => message = failure.message,
      (successMessage) => message = successMessage,
    );

    await loadWatchlistStatus(movie.id);
    emit(WatchlistStatusState(false, message ?? ''));
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    emit(WatchlistStatusState(result, ''));
  }
}

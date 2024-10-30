import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ditonton/feature/movie/domain/entities/movie.dart';
import 'package:ditonton/feature/movie/domain/entities/movie_detail.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_watchlist_status_movies.dart';
import 'package:ditonton/feature/movie/domain/usecases/remove_watchlist_movies.dart';
import 'package:ditonton/feature/movie/domain/usecases/save_watchlist_movies.dart';

// Define states for MovieDetailCubit
part 'movie_detail_state.dart';

class MovieDetailCubit extends Cubit<MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatusMovies getWatchListStatus;
  final SaveWatchlistMovies saveWatchlist;
  final RemoveWatchlistMovies removeWatchlist;

  MovieDetailCubit({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(MovieDetailInitial());

  Future<void> fetchMovieDetail(int id) async {
    emit(MovieDetailLoading());
    final detailResult = await getMovieDetail.execute(id);
    final recommendationResult = await getMovieRecommendations.execute(id);
    final isAddedToWatchlistResult = await getWatchListStatus.execute(id);

    detailResult.fold(
      (failure) => emit(MovieDetailError(failure.message)),
      (movie) {
        recommendationResult.fold(
          (failure) => emit(MovieDetailLoaded(movie, [], isAddedToWatchlistResult)),
          (movies) => emit(MovieDetailLoaded(movie, movies, isAddedToWatchlistResult)),
        );
      },
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

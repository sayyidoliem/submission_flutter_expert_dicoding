part of 'watchlist_movie_cubit.dart';

abstract class WatchlistMoviesState extends Equatable {
  const WatchlistMoviesState();

  @override
  List<Object> get props => [];
}

class WatchlistMoviesInitial extends WatchlistMoviesState {}

class WatchlistMoviesLoading extends WatchlistMoviesState {}

class WatchlistMoviesLoaded extends WatchlistMoviesState {
  final List<Movie> watchlistMovies;

  const WatchlistMoviesLoaded(this.watchlistMovies);

  @override
  List<Object> get props => [watchlistMovies];
}

class WatchlistMoviesError extends WatchlistMoviesState {
  final String message;

  const WatchlistMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

final class MovieWatchlistStatusState extends WatchlistMoviesState {
  final bool isAddedToWatchlist;
  final String message;

  MovieWatchlistStatusState(this.isAddedToWatchlist, this.message);

  @override
  List<Object> get props => [isAddedToWatchlist, message];
}

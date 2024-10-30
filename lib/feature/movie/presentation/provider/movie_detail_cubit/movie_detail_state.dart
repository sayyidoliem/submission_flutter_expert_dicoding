part of 'movie_detail_cubit.dart';

sealed class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object> get props => [];
}

final class MovieDetailInitial extends MovieDetailState {}

final class MovieDetailLoading extends MovieDetailState {}

final class MovieDetailLoaded extends MovieDetailState {
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedToWatchlist;

  MovieDetailLoaded(this.movie, this.recommendations, this.isAddedToWatchlist);

  MovieDetailLoaded copyWith({
    MovieDetail? movie,
    List<Movie>? recommendations,
    bool? isAddedToWatchlist,
  }) {
    return MovieDetailLoaded(
      movie ?? this.movie,
      recommendations ?? this.recommendations,
      isAddedToWatchlist ?? this.isAddedToWatchlist,
    );
  }

  @override
  List<Object> get props => [movie, recommendations, isAddedToWatchlist];
}

final class MovieDetailError extends MovieDetailState {
  final String message;

  MovieDetailError(this.message);

  @override
  List<Object> get props => [message];
}

final class WatchlistStatusState extends MovieDetailState {
  final bool isAddedToWatchlist;
  final String message;

  WatchlistStatusState(this.isAddedToWatchlist, this.message);

  @override
  List<Object> get props => [isAddedToWatchlist, message];
}

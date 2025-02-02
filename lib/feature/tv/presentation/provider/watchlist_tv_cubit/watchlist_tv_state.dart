part of 'watchlist_tv_cubit.dart';

abstract class WatchlistTvState {
  const WatchlistTvState();
}

class WatchlistTvInitial extends WatchlistTvState {}

class WatchlistTvLoading extends WatchlistTvState {}

class WatchlistTvLoaded extends WatchlistTvState {
  final List<Tv> watchlistTvs;

  WatchlistTvLoaded(this.watchlistTvs);
}

class WatchlistTvError extends WatchlistTvState {
  final String message;

  WatchlistTvError(this.message);
}

final class TvDetailWatchlistUpdated extends WatchlistTvState {
  final String message;

  TvDetailWatchlistUpdated(this.message);

  List<Object> get props => [message];
}

final class TvWatchlistStatusState extends WatchlistTvState {
  final bool isAddedToWatchlist;
  final String message;

  TvWatchlistStatusState(this.isAddedToWatchlist, this.message);

  List<Object> get props => [isAddedToWatchlist, message];
}

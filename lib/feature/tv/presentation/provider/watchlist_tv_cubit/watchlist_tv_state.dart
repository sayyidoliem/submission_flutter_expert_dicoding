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

part of 'tv_list_cubit.dart';

abstract class TvListState extends Equatable {
  @override
  List<Object> get props => [];
}

class TvListInitial extends TvListState {}

class TvListLoading extends TvListState {}

class NowPlayingTvsLoaded extends TvListState {
  final List<Tv> nowPlayingTvs;

  NowPlayingTvsLoaded(this.nowPlayingTvs);

  @override
  List<Object> get props => [nowPlayingTvs];
}

class PopularTvsLoaded extends TvListState {
  final List<Tv> popularTvs;

  PopularTvsLoaded(this.popularTvs);

  @override
  List<Object> get props => [popularTvs];
}

class TopRatedTvsLoaded extends TvListState {
  final List<Tv> topRatedTvs;

  TopRatedTvsLoaded(this.topRatedTvs);

  @override
  List<Object> get props => [topRatedTvs];
}

class TvListError extends TvListState {
  final String message;

  TvListError(this.message);

  @override
  List<Object> get props => [message];
}

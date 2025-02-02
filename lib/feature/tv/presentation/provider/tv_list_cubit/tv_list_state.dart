part of 'tv_list_cubit.dart';

abstract class TvListState extends Equatable {
  @override
  List<Object> get props => [];
}

class TvListInitial extends TvListState {}

class TvListLoading extends TvListState {}

class NowPlayingTvListLoaded extends TvListState {
  final List<Tv> nowPlayingTvs;

  NowPlayingTvListLoaded(this.nowPlayingTvs);

  @override
  List<Object> get props => [nowPlayingTvs];
}

class PopularTvListLoaded extends TvListState {
  final List<Tv> popularTvs;

  PopularTvListLoaded(this.popularTvs);

  @override
  List<Object> get props => [popularTvs];
}

class TopRatedTvListLoaded extends TvListState {
  final List<Tv> topRatedTvs;

  TopRatedTvListLoaded(this.topRatedTvs);

  @override
  List<Object> get props => [topRatedTvs];
}

class TvListError extends TvListState {
  final String message;

  TvListError(this.message);

  @override
  List<Object> get props => [message];
}

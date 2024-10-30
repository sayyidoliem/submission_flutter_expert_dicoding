part of 'now_play_tvs_cubit.dart';

abstract class NowPlayingTvsState extends Equatable {
  const NowPlayingTvsState();

  @override
  List<Object> get props => [];
}

class NowPlayingTvsInitial extends NowPlayingTvsState {}

class NowPlayingTvsLoading extends NowPlayingTvsState {}

class NowPlayingTvsLoaded extends NowPlayingTvsState {
  final List<Tv> nowPlayingTvs;

  const NowPlayingTvsLoaded(this.nowPlayingTvs);

  @override
  List<Object> get props => [nowPlayingTvs];
}

class NowPlayingTvsError extends NowPlayingTvsState {
  final String message;

  const NowPlayingTvsError(this.message);

  @override
  List<Object> get props => [message];
}
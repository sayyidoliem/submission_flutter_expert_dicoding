part of 'top_rated_tvs_cubit.dart';

sealed class TopRatedTvsState extends Equatable {
  const TopRatedTvsState();

  @override
  List<Object> get props => [];
}

final class TopRatedTvsInitial extends TopRatedTvsState {}

final class TopRatedTvsLoading extends TopRatedTvsState {}

final class TopRatedTvsLoaded extends TopRatedTvsState {
  final List<Tv> tvs;

  const TopRatedTvsLoaded(this.tvs);

  @override
  List<Object> get props => [tvs];
}

final class TopRatedTvsError extends TopRatedTvsState {
  final String message;

  const TopRatedTvsError(this.message);

  @override
  List<Object> get props => [message];
}
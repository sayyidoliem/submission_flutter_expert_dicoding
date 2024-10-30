part of 'popular_tvs_cubit.dart';

abstract class PopularTvsState extends Equatable {
  @override
  List<Object> get props => [];
}

class PopularTvsInitial extends PopularTvsState {}

class PopularTvsLoading extends PopularTvsState {}

class PopularTvsLoaded extends PopularTvsState {
  final List<Tv> tvs;

  PopularTvsLoaded(this.tvs);

  @override
  List<Object> get props => [tvs];
}

class PopularTvsError extends PopularTvsState {
  final String message;

  PopularTvsError(this.message);

  @override
  List<Object> get props => [message];
}
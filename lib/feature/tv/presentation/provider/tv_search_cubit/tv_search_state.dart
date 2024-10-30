part of 'tv_search_cubit.dart';

abstract class TvSearchState extends Equatable {
  const TvSearchState();

  @override
  List<Object> get props => [];
}

class TvSearchInitial extends TvSearchState {}

class TvSearchLoading extends TvSearchState {}

class TvSearchLoaded extends TvSearchState {
  final List<Tv> searchResults;

  const TvSearchLoaded(this.searchResults);

  @override
  List<Object> get props => [searchResults];
}

class TvSearchError extends TvSearchState {
  final String message;

  const TvSearchError(this.message);

  @override
  List<Object> get props => [message];
}

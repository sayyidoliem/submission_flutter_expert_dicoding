part of 'tv_detail_cubit.dart';

sealed class TvDetailState extends Equatable {
  const TvDetailState();

  @override
  List<Object> get props => [];
}

final class TvDetailInitial extends TvDetailState {}

final class TvDetailLoading extends TvDetailState {}

final class TvDetailLoaded extends TvDetailState {
  final TvDetail tv;
  final List<Tv> recommendations;
  final bool isAddedToWatchlist;

  TvDetailLoaded(this.tv, this.recommendations, this.isAddedToWatchlist);

  TvDetailLoaded copyWith({
    TvDetail? tv,
    List<Tv>? recommendations,
    bool? isAddedToWatchlist,
  }) {
    return TvDetailLoaded(
      tv ?? this.tv,
      recommendations ?? this.recommendations,
      isAddedToWatchlist ?? this.isAddedToWatchlist,
    );
  }

  @override
  List<Object> get props => [tv, recommendations, isAddedToWatchlist];
}

final class TvDetailError extends TvDetailState {
  final String message;

  TvDetailError(this.message);

  @override
  List<Object> get props => [message];
}

final class TvDetailWatchlistUpdated extends TvDetailState {
  final String message;

  TvDetailWatchlistUpdated(this.message);

  @override
  List<Object> get props => [message];
}

final class TvDetailWatchlistStatus extends TvDetailState {
  final bool isAddedToWatchlist;
  final String message;

  TvDetailWatchlistStatus(this.isAddedToWatchlist, this.message);

  @override
  List<Object> get props => [isAddedToWatchlist, message];
}

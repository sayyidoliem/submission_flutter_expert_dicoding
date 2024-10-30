import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/feature/movie/presentation/provider/watchlist_movie_cubit/watchlist_movie_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_movie_notifier_test.mocks.dart';


@GenerateMocks([GetWatchlistMovies])
void main() {
  late WatchlistMoviesCubit cubit;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    cubit = WatchlistMoviesCubit(getWatchlistMovies: mockGetWatchlistMovies);
  });

  test('should emit [WatchlistMovieLoading, WatchlistMovieLoaded] when data is fetched successfully', () async {
    // arrange
    when(mockGetWatchlistMovies.execute())
        .thenAnswer((_) async => Right([testWatchlistMovie]));
    // act
    await cubit.fetchWatchlistMovies();
    // assert
    expect(cubit.state, isA<WatchlistMoviesLoaded>());
    expect((cubit.state as WatchlistMoviesLoaded).watchlistMovies, [testWatchlistMovie]);
  });

  test('should emit [WatchlistMovieLoading, WatchlistMovieError] when fetching data fails', () async {
    // arrange
    when(mockGetWatchlistMovies.execute())
        .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
    // act
    await cubit.fetchWatchlistMovies();
    // assert
    expect(cubit.state, isA<WatchlistMoviesError>());
    expect((cubit.state as WatchlistMoviesError).message, "Can't get data");
  });

  test('should emit [WatchlistMovieLoading] when the fetch is initiated', () async {
    // arrange
    when(mockGetWatchlistMovies.execute())
        .thenAnswer((_) async => Right([testWatchlistMovie]));
    // act
    expect(cubit.state, isA<WatchlistMoviesInitial>());
    await cubit.fetchWatchlistMovies();
    // assert
    expect(cubit.state, isA<WatchlistMoviesLoading>());
  });
}

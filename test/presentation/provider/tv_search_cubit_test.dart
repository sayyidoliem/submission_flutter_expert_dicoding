import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/feature/movie/presentation/provider/watchlist_movie_cubit/watchlist_movie_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_search_cubit_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late WatchlistMoviesCubit cubit;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    cubit = WatchlistMoviesCubit(getWatchlistMovies: mockGetWatchlistMovies);
  });

  group('fetchWatchlistMovies', () {
    test('should emit [WatchlistMoviesLoading, WatchlistMoviesLoaded] when data is fetched successfully', () async {
      // arrange
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right([testWatchlistMovie]));

      // assert later on emitted states
      final expectedStates = [
        WatchlistMoviesLoading(),
        WatchlistMoviesLoaded([testWatchlistMovie]),
      ];

      // act
      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.fetchWatchlistMovies();
    });

    test('should emit [WatchlistMoviesLoading, WatchlistMoviesError] when fetching data fails', () async {
      // arrange
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));

      // assert later on emitted states
      final expectedStates = [
        WatchlistMoviesLoading(),
        WatchlistMoviesError("Can't get data"),
      ];

      // act
      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.fetchWatchlistMovies();
    });

    test('should emit [WatchlistMoviesLoading] when the fetch is initiated', () async {
      // arrange
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right([testWatchlistMovie]));

      // act
      expect(cubit.state, isA<WatchlistMoviesInitial>());

      // Start the fetch process
      await cubit.fetchWatchlistMovies();

      // assert that loading state is emitted
      expect(cubit.state, isA<WatchlistMoviesLoading>());
    });
  });
}

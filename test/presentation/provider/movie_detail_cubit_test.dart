import 'package:dartz/dartz.dart';
import 'package:ditonton/feature/movie/domain/entities/movie.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_watchlist_status_movies.dart';
import 'package:ditonton/feature/movie/domain/usecases/remove_watchlist_movies.dart';
import 'package:ditonton/feature/movie/domain/usecases/save_watchlist_movies.dart';
import 'package:ditonton/feature/movie/presentation/provider/movie_detail_cubit/movie_detail_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_cubit_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatusMovies,
  SaveWatchlistMovies,
  RemoveWatchlistMovies,
])
void main() {
  late MovieDetailCubit cubit;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatusMovies mockGetWatchlistStatus;
  late MockSaveWatchlistMovies mockSaveWatchlist;
  late MockRemoveWatchlistMovies mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatusMovies();
    mockSaveWatchlist = MockSaveWatchlistMovies();
    mockRemoveWatchlist = MockRemoveWatchlistMovies();
    cubit = MovieDetailCubit(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  final tId = 1;

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovies = <Movie>[tMovie];

  void _arrangeUsecase() {
    when(mockGetMovieDetail.execute(tId)).thenAnswer((_) async => Right(testMovieDetail));
    when(mockGetMovieRecommendations.execute(tId)).thenAnswer((_) async => Right(tMovies));
  }

  group('Get Movie Detail', () {
    blocTest<MovieDetailCubit, MovieDetailState>(
      'should get data from the usecase',
      build: () {
        _arrangeUsecase();
        // Stub the getWatchlistStatus to avoid MissingStubError
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => false);
        return cubit;
      },
      act: (cubit) => cubit.fetchMovieDetail(tId),
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'should emit Loading and then Loaded states when usecase is called',
      build: () {
        _arrangeUsecase();
        // Stub the getWatchlistStatus to avoid MissingStubError
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => false);
        return cubit;
      },
      act: (cubit) => cubit.fetchMovieDetail(tId),
      expect: () => [
        isA<MovieDetailLoading>(),
        isA<MovieDetailLoaded>(),
      ],
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'should change movie when data is gotten successfully',
      build: () {
        _arrangeUsecase();
        // Stub the getWatchlistStatus to avoid MissingStubError
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => false);
        return cubit;
      },
      act: (cubit) async => await cubit.fetchMovieDetail(tId),
      expect: () => [
        isA<MovieDetailLoading>(),
        isA<MovieDetailLoaded>().having((state) => (state as MovieDetailLoaded).movie, 'movie', testMovieDetail),
      ],
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'should change recommendation movies when data is gotten successfully',
      build: () {
        _arrangeUsecase();
        // Stub the getWatchlistStatus to avoid MissingStubError
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => false);
        return cubit;
      },
      act: (cubit) async => await cubit.fetchMovieDetail(tId),
      expect: () => [
        isA<MovieDetailLoading>(),
        isA<MovieDetailLoaded>().having((state) => (state as MovieDetailLoaded).recommendations, 'recommendations', tMovies),
      ],
    );
  });

  group('Watchlist', () {
    blocTest<MovieDetailCubit, MovieDetailState>(
      'should get the watchlist status',
      build: () {
        when(mockGetWatchlistStatus.execute(1)).thenAnswer((_) async => true);
        return cubit;
      },
      act: (cubit) async => await cubit.loadWatchlistStatus(1),
      expect: () => [],
      verify: (_) {
        expect(cubit.getWatchListStatus, true);
      },
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'should execute save watchlist when function called',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer((_) async => Right('Success'));
        return cubit;
      },
      act: (cubit) async => await cubit.addWatchlist(testMovieDetail),
      verify: (_) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
      },
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'should execute remove watchlist when function called',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail)).thenAnswer((_) async => Right('Removed'));
        return cubit;
      },
      act: (cubit) async => await cubit.removeFromWatchlist(testMovieDetail),
      verify: (_) {
        verify(mockRemoveWatchlist.execute(testMovieDetail));
      },
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'should update watchlist status when add watchlist success',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer((_) async => Right('Added to Watchlist'));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id)).thenAnswer((_) async => true);
        return cubit;
      },
      act: (cubit) async => await cubit.addWatchlist(testMovieDetail),
      expect: () => [
        isA<MovieDetailLoaded>().having((state) => state.isAddedToWatchlist, 'getWatchListStatus', true),
      ],
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'should update watchlist message when add watchlist failed',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id)).thenAnswer((_) async => false);
        return cubit;
      },
      act: (cubit) async => await cubit.addWatchlist(testMovieDetail),
      expect: () => [
        isA<MovieDetailError>().having((state) => (state as MovieDetailError).message, 'message', 'Failed'),
      ],
    );
  });

  group('on Error', () {
    blocTest<MovieDetailCubit, MovieDetailState>(
      'should return error when data is unsuccessful',
      build: () {
        when(mockGetMovieDetail.execute(tId)).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetMovieRecommendations.execute(tId)).thenAnswer((_) async => Right(tMovies));
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => false);
        return cubit;
      },
      act: (cubit) async => await cubit.fetchMovieDetail(tId),
      expect: () => [
        isA<MovieDetailError>().having((state) => (state as MovieDetailError).message, 'message', 'Server Failure'),
      ],
    );
  });
}

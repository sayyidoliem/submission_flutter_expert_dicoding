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
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await cubit.fetchMovieDetail(tId);
      // assert
      verify(mockGetMovieDetail.execute(tId));
      verify(mockGetMovieRecommendations.execute(tId));
    });

    test('should emit Loading and then Loaded states when usecase is called', () {
      // arrange
      _arrangeUsecase();
      // act
      cubit.fetchMovieDetail(tId);
      // assert
      expectLater(cubit.stream, emitsInOrder([isA<MovieDetailLoading>(), isA<MovieDetailLoaded>()]));
    });

    test('should change movie when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await cubit.fetchMovieDetail(tId);
      // assert
      expect(cubit.state, isA<MovieDetailLoaded>());
      expect((cubit.state as MovieDetailLoaded).movie, testMovieDetail);
    });

    test('should change recommendation movies when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await cubit.fetchMovieDetail(tId);
      // assert
      expect(cubit.state, isA<MovieDetailLoaded>());
      expect((cubit.state as MovieDetailLoaded).recommendations, tMovies);
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      // arrange
      when(mockGetWatchlistStatus.execute(1)).thenAnswer((_) async => true);
      // act
      await cubit.loadWatchlistStatus(1);
      // assert
      expect(cubit.getWatchListStatus, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer((_) async => Right('Success'));
      when(mockGetWatchlistStatus.execute(testMovieDetail.id)).thenAnswer((_) async => true);
      // act
      await cubit.addWatchlist(testMovieDetail);
      // assert
      verify(mockSaveWatchlist.execute(testMovieDetail));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(mockRemoveWatchlist.execute(testMovieDetail)).thenAnswer((_) async => Right('Removed'));
      when(mockGetWatchlistStatus.execute(testMovieDetail.id)).thenAnswer((_) async => false);
      // act
      await cubit.removeFromWatchlist(testMovieDetail);
      // assert
      verify(mockRemoveWatchlist.execute(testMovieDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchlistStatus.execute(testMovieDetail.id)).thenAnswer((_) async => true);
      // act
      await cubit.addWatchlist(testMovieDetail);
      // assert
      expect(cubit.getWatchListStatus, true);
      expect(cubit.getWatchListStatus, 'Added to Watchlist');
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistStatus.execute(testMovieDetail.id)).thenAnswer((_) async => false);
      // act
      await cubit.addWatchlist(testMovieDetail);
      // assert
      expect(cubit.getWatchListStatus, 'Failed');
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetMovieDetail.execute(tId)).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetMovieRecommendations.execute(tId)).thenAnswer((_) async => Right(tMovies));
      // act
      await cubit.fetchMovieDetail(tId);
      // assert
      expect(cubit.state, isA<MovieDetailError>());
      expect((cubit.state as MovieDetailError).message, 'Server Failure');
    });
  });
}

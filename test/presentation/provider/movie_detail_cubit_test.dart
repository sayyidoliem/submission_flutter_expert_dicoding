import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/feature/movie/domain/entities/movie.dart';
import 'package:ditonton/feature/movie/domain/entities/movie_detail.dart';
import 'package:ditonton/feature/movie/domain/entities/movie_genre.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_watchlist_status_movies.dart';
import 'package:ditonton/feature/movie/presentation/provider/movie_detail_cubit/movie_detail_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_detail_cubit_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatusMovies,
])
void main() {
  late MovieDetailCubit movieDetailCubit;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatusMovies mockGetWatchListStatus;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatusMovies();
    movieDetailCubit = MovieDetailCubit(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchListStatus,
    );
  });

  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: '/path.jpg',
    genres: [
      MovieGenre(id: 1, name: 'Action'),
    ],
    id: 1,
    originalTitle: 'Original Title',
    overview: 'Overview',
    posterPath: '/path.jpg',
    releaseDate: '2020-05-05',
    runtime: 120,
    title: 'Title',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tMovieList = <Movie>[
    Movie(
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
    )
  ];

  final tMovieId = 1;

  group('MovieDetailCubit', () {
    blocTest<MovieDetailCubit, MovieDetailState>(
      'should emit [MovieDetailLoading, MovieDetailLoaded] when movie detail and recommendations are fetched successfully',
      build: () {
        when(mockGetMovieDetail.execute(tMovieId))
            .thenAnswer((_) async => Right(tMovieDetail));
        when(mockGetMovieRecommendations.execute(tMovieId))
            .thenAnswer((_) async => Right(tMovieList));
        when(mockGetWatchListStatus.execute(tMovieId))
            .thenAnswer((_) async => true);
        return movieDetailCubit;
      },
      act: (cubit) async => await cubit.fetchMovieDetail(tMovieId),
      expect: () => [
        MovieDetailLoading(),
        MovieDetailLoaded(tMovieDetail, tMovieList, true),
      ],
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'should emit [MovieDetailLoading, MovieDetailError] when movie detail fetch fails',
      build: () {
        when(mockGetMovieDetail.execute(tMovieId)).thenAnswer(
            (_) async => Left(ServerFailure('Failed to fetch movie detail')));
        when(mockGetMovieRecommendations.execute(tMovieId))
            .thenAnswer((_) async => Right([]));
        when(mockGetWatchListStatus.execute(tMovieId))
            .thenAnswer((_) async => true);
        return movieDetailCubit;
      },
      act: (cubit) async => await cubit.fetchMovieDetail(tMovieId),
      expect: () => [
        MovieDetailLoading(),
        MovieDetailError('Failed to fetch movie detail'),
      ],
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'should emit [MovieDetailLoaded] and watchlist added message when movie is added to watchlist',
      build: () {
        when(mockGetMovieDetail.execute(tMovieId))
            .thenAnswer((_) async => Right(tMovieDetail));
        when(mockGetMovieRecommendations.execute(tMovieId))
            .thenAnswer((_) async => Right(tMovieList));
        when(mockGetWatchListStatus.execute(tMovieId))
            .thenAnswer((_) async => true);
        return movieDetailCubit;
      },
      act: (cubit) async => await cubit.fetchMovieDetail(tMovieId),
      expect: () => [
        MovieDetailLoading(),
        MovieDetailLoaded(tMovieDetail, tMovieList, true),
      ],
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'should emit MovieDetailError when add to watchlist fails',
      build: () {
        when(mockGetMovieDetail.execute(tMovieId))
            .thenAnswer((_) async => Right(tMovieDetail));
        when(mockGetMovieRecommendations.execute(tMovieId))
            .thenAnswer((_) async => Right(tMovieList));
        when(mockGetWatchListStatus.execute(tMovieId))
            .thenAnswer((_) async => false);
        return movieDetailCubit;
      },
      act: (cubit) async => await cubit.fetchMovieDetail(tMovieId),
      expect: () => [
        MovieDetailLoading(),
        MovieDetailLoaded(tMovieDetail, tMovieList, false),
      ],
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'should emit MovieDetailLoaded when movie is removed from watchlist',
      build: () {
        when(mockGetMovieDetail.execute(tMovieId))
            .thenAnswer((_) async => Right(tMovieDetail));
        when(mockGetMovieRecommendations.execute(tMovieId))
            .thenAnswer((_) async => Right(tMovieList));
        when(mockGetWatchListStatus.execute(tMovieId))
            .thenAnswer((_) async => false);
        return movieDetailCubit;
      },
      act: (cubit) async => await cubit.fetchMovieDetail(tMovieId),
      expect: () => [
        MovieDetailLoading(),
        MovieDetailLoaded(tMovieDetail, tMovieList, false),
      ],
    );
  });
}

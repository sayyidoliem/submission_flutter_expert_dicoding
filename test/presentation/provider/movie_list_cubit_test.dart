import 'package:dartz/dartz.dart';
import 'package:ditonton/feature/movie/domain/entities/movie.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/feature/movie/presentation/provider/movie_list_cubit/movie_list_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_list_cubit_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetPopularMovies, GetTopRatedMovies])
void main() {
  late MovieListCubit cubit;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    cubit = MovieListCubit(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
    );
  });

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
  
  final tMovieList = <Movie>[tMovie];

  group('Now Playing Movies', () {
    test('initialState should be Empty', () {
      expect(cubit.state, MovieListInitial());
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetNowPlayingMovies.execute()).thenAnswer((_) async => Right(tMovieList));
      // act
      await cubit.fetchNowPlayingMovies();
      // assert
      verify(mockGetNowPlayingMovies.execute());
    });

    test('should change state to Loading when usecase is called', () async {
      // arrange
      when(mockGetNowPlayingMovies.execute()).thenAnswer((_) async => Right(tMovieList));
      // act
      await cubit.fetchNowPlayingMovies();
      // assert
      expect(cubit.state, MovieListLoading());
    });

    test('should change movies when data is gotten successfully', () async {
      // arrange
      when(mockGetNowPlayingMovies.execute()).thenAnswer((_) async => Right(tMovieList));
      // act
      await cubit.fetchNowPlayingMovies();
      // assert
      expect(cubit.state, MovieListLoaded(tMovieList));
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetNowPlayingMovies.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await cubit.fetchNowPlayingMovies();
      // assert
      expect(cubit.state, MovieListError('Server Failure'));
    });
  });

  group('Popular Movies', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetPopularMovies.execute()).thenAnswer((_) async => Right(tMovieList));
      // act
      await cubit.fetchPopularMovies();
      // assert
      expect(cubit.state, MovieListLoading());
    });

    test('should change movies data when data is gotten successfully', () async {
      // arrange
      when(mockGetPopularMovies.execute()).thenAnswer((_) async => Right(tMovieList));
      // act
      await cubit.fetchPopularMovies();
      // assert
      expect(cubit.state, MovieListLoaded(tMovieList));
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPopularMovies.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await cubit.fetchPopularMovies();
      // assert
      expect(cubit.state, MovieListError('Server Failure'));
    });
  });

  group('Top Rated Movies', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetTopRatedMovies.execute()).thenAnswer((_) async => Right(tMovieList));
      // act
      await cubit.fetchTopRatedMovies();
      // assert
      expect(cubit.state, MovieListLoading());
    });

    test('should change movies data when data is gotten successfully', () async {
      // arrange
      when(mockGetTopRatedMovies.execute()).thenAnswer((_) async => Right(tMovieList));
      // act
      await cubit.fetchTopRatedMovies();
      // assert
      expect(cubit.state, MovieListLoaded(tMovieList));
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedMovies.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await cubit.fetchTopRatedMovies();
      // assert
      expect(cubit.state, MovieListError('Server Failure'));
    });
  });
}

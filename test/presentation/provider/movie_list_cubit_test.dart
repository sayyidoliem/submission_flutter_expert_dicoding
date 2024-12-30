import 'package:bloc_test/bloc_test.dart';
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
    blocTest<MovieListCubit, MovieListState>(
      'initialState should be Empty',
      build: () => cubit,
      expect: () => [],
    );

    blocTest<MovieListCubit, MovieListState>(
      'should get data from the usecase',
      build: () {
        when(mockGetNowPlayingMovies.execute()).thenAnswer((_) async => Right(tMovieList));
        return cubit;
      },
      act: (cubit) async => await cubit.fetchNowPlayingMovies(),
      verify: (cubit) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );

    blocTest<MovieListCubit, MovieListState>(
      'should change state to Loading when usecase is called',
      build: () {
        when(mockGetNowPlayingMovies.execute()).thenAnswer((_) async => Right(tMovieList));
        return cubit;
      },
      act: (cubit) async => await cubit.fetchNowPlayingMovies(),
      expect: () => [MovieListLoading(), MovieListLoaded(tMovieList)],
    );

    blocTest<MovieListCubit, MovieListState>(
      'should return error when data is unsuccessful',
      build: () {
        when(mockGetNowPlayingMovies.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return cubit;
      },
      act: (cubit) async => await cubit.fetchNowPlayingMovies(),
      expect: () => [MovieListLoading(), MovieListError('Server Failure')],
    );
  });

  group('Popular Movies', () {
    blocTest<MovieListCubit, MovieListState>(
      'should change state to Loading when usecase is called',
      build: () {
        when(mockGetPopularMovies.execute()).thenAnswer((_) async => Right(tMovieList));
        return cubit;
      },
      act: (cubit) async => await cubit.fetchPopularMovies(),
      expect: () => [MovieListLoading(), MovieListLoaded(tMovieList)],
    );

    blocTest<MovieListCubit, MovieListState>(
      'should return error when data is unsuccessful',
      build: () {
        when(mockGetPopularMovies.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return cubit;
      },
      act: (cubit) async => await cubit.fetchPopularMovies(),
      expect: () => [MovieListLoading(), MovieListError('Server Failure')],
    );
  });

  group('Top Rated Movies', () {
    blocTest<MovieListCubit, MovieListState>(
      'should change state to Loading when usecase is called',
      build: () {
        when(mockGetTopRatedMovies.execute()).thenAnswer((_) async => Right(tMovieList));
        return cubit;
      },
      act: (cubit) async => await cubit.fetchTopRatedMovies(),
      expect: () => [MovieListLoading(), MovieListLoaded(tMovieList)],
    );

    blocTest<MovieListCubit, MovieListState>(
      'should return error when data is unsuccessful',
      build: () {
        when(mockGetTopRatedMovies.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return cubit;
      },
      act: (cubit) async => await cubit.fetchTopRatedMovies(),
      expect: () => [MovieListLoading(), MovieListError('Server Failure')],
    );
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/feature/movie/domain/entities/movie.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/feature/movie/presentation/provider/top_rated_movie_cubit/top_rated_movie_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_list_cubit_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late TopRatedMoviesCubit cubit;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    cubit = TopRatedMoviesCubit(mockGetTopRatedMovies);
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

  group('TopRatedMoviesCubit', () {
    blocTest<TopRatedMoviesCubit, TopRatedMoviesState>(
      'should emit [TopRatedMoviesLoading, TopRatedMoviesLoaded] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedMovies.execute()).thenAnswer((_) async => Right(tMovieList));
        return cubit;
      },
      act: (cubit) async => await cubit.fetchTopRatedMovies(),
      expect: () => [TopRatedMoviesLoading(), TopRatedMoviesLoaded(tMovieList)],
    );

    blocTest<TopRatedMoviesCubit, TopRatedMoviesState>(
      'should emit [TopRatedMoviesLoading, TopRatedMoviesError] when getting data fails',
      build: () {
        when(mockGetTopRatedMovies.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return cubit;
      },
      act: (cubit) async => await cubit.fetchTopRatedMovies(),
      expect: () => [TopRatedMoviesLoading(), TopRatedMoviesError('Server Failure')],
    );
  });
}

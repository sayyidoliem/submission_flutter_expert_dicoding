import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/feature/movie/domain/entities/movie.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/feature/movie/presentation/provider/popular_movie_cubit/popular_movie_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_movies_cubit_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late MockGetPopularMovies mockGetPopularMovies;
  late PopularMoviesCubit cubit;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    cubit = PopularMoviesCubit(mockGetPopularMovies);
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

  group('PopularMoviesCubit', () {
    blocTest<PopularMoviesCubit, PopularMoviesState>(
      'should emit [PopularMoviesLoading, PopularMoviesLoaded] when data is gotten successfully',
      build: () {
        when(mockGetPopularMovies.execute()).thenAnswer((_) async => Right(tMovieList));
        return cubit;
      },
      act: (cubit) async => await cubit.fetchPopularMovies(),
      expect: () => [PopularMoviesLoading(), PopularMoviesLoaded(tMovieList)],
    );

    blocTest<PopularMoviesCubit, PopularMoviesState>(
      'should emit [PopularMoviesLoading, PopularMoviesError] when getting data fails',
      build: () {
        when(mockGetPopularMovies.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return cubit;
      },
      act: (cubit) async => await cubit.fetchPopularMovies(),
      expect: () => [PopularMoviesLoading(), PopularMoviesError('Server Failure')],
    );
  });
}

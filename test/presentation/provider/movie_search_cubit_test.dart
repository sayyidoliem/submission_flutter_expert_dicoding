import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/feature/movie/domain/entities/movie.dart';
import 'package:ditonton/feature/movie/domain/usecases/search_movies.dart';
import 'package:ditonton/feature/movie/presentation/provider/movie_search_cubit/movie_search_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_search_cubit_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late MovieSearchCubit cubit;
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    cubit = MovieSearchCubit(searchMovies: mockSearchMovies);
  });

  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview: 'After being bitten by a genetically altered spider...',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tMovieList = <Movie>[tMovieModel];
  final tQuery = 'spiderman';

  group('Search Movies', () {
    blocTest<MovieSearchCubit, MovieSearchState>(
      'should change state to loading when usecase is called',
      build: () {
        when(mockSearchMovies.execute(tQuery)).thenAnswer((_) async => Right(tMovieList));
        return cubit;
      },
      act: (cubit) async => await cubit.fetchMovieSearch(tQuery),
      expect: () => [MovieSearchLoading(), MovieSearchLoaded(tMovieList)],
    );

    blocTest<MovieSearchCubit, MovieSearchState>(
      'should return error when data is unsuccessful',
      build: () {
        when(mockSearchMovies.execute(tQuery)).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return cubit;
      },
      act: (cubit) async => await cubit.fetchMovieSearch(tQuery),
      expect: () => [MovieSearchLoading(), MovieSearchError('Server Failure')],
    );
  });
}

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/feature/tv/domain/entities/tv.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_popular_tvs.dart';
import 'package:ditonton/feature/tv/presentation/provider/popular_tvs_cubit/popular_tvs_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tv_cubit_test.mocks.dart';


@GenerateMocks([GetPopularTvs])
void main() {
  late MockGetPopularTvs mockGetPopularTvs;
  late PopularTvsCubit cubit;

  setUp(() {
    mockGetPopularTvs = MockGetPopularTvs();
    cubit = PopularTvsCubit( mockGetPopularTvs);
  });

  final tTv = Tv(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
    originalName: 'originalName',
    firstAirDate: 'firstAirDate',
    name: 'name',
  );

  final tTvList = <Tv>[tTv];

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetPopularTvs.execute())
        .thenAnswer((_) async => Right(tTvList));
    // act
    await cubit.fetchPopularTvs();
    // assert
    expect(cubit.state, PopularTvsLoading());
  });

  test('should change tvs data when data is gotten successfully', () async {
    // arrange
    when(mockGetPopularTvs.execute())
        .thenAnswer((_) async => Right(tTvList));
    // act
    await cubit.fetchPopularTvs();
    // assert
    expect(cubit.state, PopularTvsLoaded(tTvList));
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetPopularTvs.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await cubit.fetchPopularTvs();
    // assert
    expect(cubit.state, PopularTvsError('Server Failure'));
  });
}

import 'package:bloc_test/bloc_test.dart';
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
    cubit = PopularTvsCubit(mockGetPopularTvs);
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

  group('PopularTvsCubit', () {
    blocTest<PopularTvsCubit, PopularTvsState>(
      'should emit [PopularTvsLoading, PopularTvsLoaded] when data is gotten successfully',
      build: () {
        when(mockGetPopularTvs.execute()).thenAnswer((_) async => Right(tTvList));
        return cubit;
      },
      act: (cubit) async => await cubit.fetchPopularTvs(),
      expect: () => [PopularTvsLoading(), PopularTvsLoaded(tTvList)],
    );

    blocTest<PopularTvsCubit, PopularTvsState>(
      'should emit [PopularTvsLoading, PopularTvsError] when getting data fails',
      build: () {
        when(mockGetPopularTvs.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return cubit;
      },
      act: (cubit) async => await cubit.fetchPopularTvs(),
      expect: () => [PopularTvsLoading(), PopularTvsError('Server Failure')],
    );
  });
}

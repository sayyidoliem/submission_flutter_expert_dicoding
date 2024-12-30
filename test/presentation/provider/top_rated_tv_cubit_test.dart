import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/feature/tv/domain/entities/tv.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:ditonton/feature/tv/presentation/provider/top_rated_tvs_cubit/top_rated_tvs_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_tv_cubit_test.mocks.dart';

@GenerateMocks([GetTopRatedTvs])
void main() {
  late MockGetTopRatedTvs mockGetTopRatedTvs;
  late TopRatedTvsCubit cubit;

  setUp(() {
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    cubit = TopRatedTvsCubit(mockGetTopRatedTvs);
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

  group('TopRatedTvsCubit', () {
    blocTest<TopRatedTvsCubit, TopRatedTvsState>(
      'should emit [TopRatedTvsLoading, TopRatedTvsLoaded] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedTvs.execute()).thenAnswer((_) async => Right(tTvList));
        return cubit;
      },
      act: (cubit) async => await cubit.fetchTopRatedTvs(),
      expect: () => [TopRatedTvsLoading(), TopRatedTvsLoaded(tTvList)],
    );

    blocTest<TopRatedTvsCubit, TopRatedTvsState>(
      'should emit [TopRatedTvsLoading, TopRatedTvsError] when getting data fails',
      build: () {
        when(mockGetTopRatedTvs.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return cubit;
      },
      act: (cubit) async => await cubit.fetchTopRatedTvs(),
      expect: () => [TopRatedTvsLoading(), TopRatedTvsError('Server Failure')],
    );
  });
}

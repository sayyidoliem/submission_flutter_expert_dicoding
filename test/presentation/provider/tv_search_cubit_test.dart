import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/feature/tv/domain/entities/tv.dart';
import 'package:ditonton/feature/tv/domain/usecases/search_tvs.dart';
import 'package:ditonton/feature/tv/presentation/provider/tv_search_cubit/tv_search_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_search_cubit_test.mocks.dart';

@GenerateMocks([SearchTvs])
void main() {
  late TvSearchCubit cubit;
  late MockSearchTvs mockSearchTvs;

  setUp(() {
    mockSearchTvs = MockSearchTvs();
    cubit = TvSearchCubit(searchTvs: mockSearchTvs);
  });

  final tTv = Tv(
    adult: false,
    backdropPath: '/3HvXeJzSztADlAua3l4gjawVhPC.jpg',
    firstAirDate: '2015-01-16',
    genreIds: [16, 35],
    id: 69367,
    name: 'Saekano: How to Raise a Boring Girlfriend',
    originalName: '冴えない彼女の育てかた',
    overview: 'Tomoya Aki is an otaku who has a dream...',
    popularity: 63.749,
    posterPath: '/GP7I1yKTp6giJz2fdy0LBWo4zV.jpg',
    voteAverage: 6.7,
    voteCount: 68,
  );

  final tTvList = <Tv>[tTv];
  final tQuery = 'office';

  group('Search Tvs', () {
    blocTest<TvSearchCubit, TvSearchState>(
      'should change state to loading when usecase is called',
      build: () {
        when(mockSearchTvs.execute(tQuery))
            .thenAnswer((_) async => Right(tTvList));
        return cubit;
      },
      act: (cubit) async => await cubit.fetchTvSearch(tQuery),
      expect: () => [TvSearchLoading(), TvSearchLoaded(tTvList)],
    );

    blocTest<TvSearchCubit, TvSearchState>(
      'should return error when data is unsuccessful',
      build: () {
        when(mockSearchTvs.execute(tQuery))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return cubit;
      },
      act: (cubit) async => await cubit.fetchTvSearch(tQuery),
      expect: () => [TvSearchLoading(), TvSearchError('Server Failure')],
    );
  });
}

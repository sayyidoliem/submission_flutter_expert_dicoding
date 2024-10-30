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

  final tTvModel = Tv(
    adult: false,
    backdropPath: "/3HvXeJzSztADlAua3l4gjawVhPC.jpg",
    genreIds: [16, 35],
    id: 69367,
    originalName: "冴えない彼女の育てかた",
    overview:
        "Tomoya Aki is an otaku who has a dream. His dream is to create the best visual novel game ever.",
    popularity: 63.749,
    posterPath: "/GP7I1yKTp6giJz2fdy0LBWo4zV.jpg",
    firstAirDate: "2015-01-16",
    name: "Saekano: How to Raise a Boring Girlfriend",
    voteAverage: 6.7,
    voteCount: 68,
  );
  
  final tTvList = <Tv>[tTvModel];
  final tQuery = 'spiderman';

  group('search tvs', () {
    test('should emit [TvSearchLoading, TvSearchLoaded] when data is fetched successfully', () async {
      // arrange
      when(mockSearchTvs.execute(tQuery)).thenAnswer((_) async => Right(tTvList));
      // act
      await cubit.fetchTvSearch(tQuery);
      // assert
      expect(cubit.state, TvSearchLoaded(tTvList));
    });

    test('should emit [TvSearchLoading, TvSearchError] when fetching data fails', () async {
      // arrange
      when(mockSearchTvs.execute(tQuery)).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await cubit.fetchTvSearch(tQuery);
      // assert
      expect(cubit.state, TvSearchError('Server Failure'));
    });

    test('should emit [TvSearchLoading] when the search is initiated', () async {
      // arrange
      when(mockSearchTvs.execute(tQuery)).thenAnswer((_) async => Right(tTvList));
      // act
      expect(cubit.state, TvSearchInitial());
      await cubit.fetchTvSearch(tQuery);
      // assert
      expect(cubit.state, TvSearchLoading());
    });
  });
}

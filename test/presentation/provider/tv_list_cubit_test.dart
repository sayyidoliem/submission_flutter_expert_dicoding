import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/feature/tv/domain/entities/tv.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_now_playing_tvs.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_popular_tvs.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:ditonton/feature/tv/presentation/provider/tv_list_cubit/tv_list_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'tv_list_cubit_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvs, GetPopularTvs, GetTopRatedTvs])
void main() {
  late TvListCubit cubit;
  late MockGetNowPlayingTvs mockGetNowPlayingTvs;
  late MockGetPopularTvs mockGetPopularTvs;
  late MockGetTopRatedTvs mockGetTopRatedTvs;

  setUp(() {
    mockGetNowPlayingTvs = MockGetNowPlayingTvs();
    mockGetPopularTvs = MockGetPopularTvs();
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    cubit = TvListCubit(
      getNowPlayingTvs: mockGetNowPlayingTvs,
      getPopularTvs: mockGetPopularTvs,
      getTopRatedTvs: mockGetTopRatedTvs,
    );
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

  group('Now Playing TV Shows', () {
    test('initial state should be TvListInitial', () {
      expect(cubit.state, TvListInitial());
    });

    test('should emit [TvListLoading, TvListLoaded] when data is fetched successfully', () async {
      // arrange
      when(mockGetNowPlayingTvs.execute()).thenAnswer((_) async => Right(tTvList));
      // act
      await cubit.fetchNowPlayingTvs();
      // assert
      expect(cubit.state, NowPlayingTvsLoaded(tTvList));
    });

    test('should emit [TvListLoading, TvListError] when fetching data fails', () async {
      // arrange
      when(mockGetNowPlayingTvs.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await cubit.fetchNowPlayingTvs();
      // assert
      expect(cubit.state, TvListError('Server Failure'));
    });
  });

  group('Popular TV Shows', () {
    test('should emit [TvListLoading, TvListLoaded] when data is fetched successfully', () async {
      // arrange
      when(mockGetPopularTvs.execute()).thenAnswer((_) async => Right(tTvList));
      // act
      await cubit.fetchPopularTvs();
      // assert
      expect(cubit.state, PopularTvsLoaded(tTvList));
    });

    test('should emit [TvListLoading, TvListError] when fetching data fails', () async {
      // arrange
      when(mockGetPopularTvs.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await cubit.fetchPopularTvs();
      // assert
      expect(cubit.state, TvListError('Server Failure'));
    });
  });

  group('Top Rated TV Shows', () {
    test('should emit [TvListLoading, TvListLoaded] when data is fetched successfully', () async {
      // arrange
      when(mockGetTopRatedTvs.execute()).thenAnswer((_) async => Right(tTvList));
      // act
      await cubit.fetchTopRatedTvs();
      // assert
      expect(cubit.state, TopRatedTvsLoaded(tTvList));
    });

    test('should emit [TvListLoading, TvListError] when fetching data fails', () async {
      // arrange
      when(mockGetTopRatedTvs.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await cubit.fetchTopRatedTvs();
      // assert
      expect(cubit.state, TvListError('Server Failure'));
    });
  });
}

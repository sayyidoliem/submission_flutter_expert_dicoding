import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_watchlist_status_tvs.dart';
import 'package:ditonton/feature/tv/presentation/provider/tv_detail_cubit/tv_detail_cubit.dart';
import 'package:ditonton/feature/tv/domain/entities/tv.dart';
import 'package:ditonton/feature/tv/domain/entities/tv_detail.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'tv_detail_cubit_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
  GetWatchlistStatusTvs,
])
void main() {
  late TvDetailCubit tvDetailCubit;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetWatchlistStatusTvs mockGetWatchlistStatusTvs;

  const tTvId = 1;
  final tTvDetail = TvDetail(
    adult: false,
    backdropPath: '/path.jpg',
    episodeRunTime: [23],
    firstAirDate: '2015-01-16',
    genres: [],
    homepage: 'https://google.tv',
    id: 69367,
    inProduction: false,
    languages: ['ja'],
    lastAirDate: '2017-06-23',
    name: 'Name',
    numberOfEpisodes: 23,
    numberOfSeasons: 2,
    originCountry: ['JP'],
    originalLanguage: 'ja',
    originalName: '冴えない彼女の育てかた',
    overview: 'Some overview',
    popularity: 63.749,
    posterPath: '/GP7I1yKTp6giJz2fdy0LBWo4zV.jpg',
    status: 'Ended',
    tagline: '',
    voteAverage: 6.7,
    voteCount: 68,
  );

  final tTvList = <Tv>[
    Tv(
      adult: false,
      backdropPath: '/path.jpg',
      genreIds: [1, 2, 3, 4],
      id: 1,
      overview: 'Overview',
      popularity: 1.0,
      posterPath: '/path.jpg',
      voteAverage: 1.0,
      voteCount: 1,
      firstAirDate: '2008-01-20',
      name: 'Name',
      originalName: 'Original Name',
    )
  ];

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetWatchlistStatusTvs = MockGetWatchlistStatusTvs();
    tvDetailCubit = TvDetailCubit(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
      getWatchListStatus: mockGetWatchlistStatusTvs,
    );
  });

  group('TvDetailCubit', () {
    blocTest<TvDetailCubit, TvDetailState>(
      'emits [TvDetailLoading, TvDetailLoaded] on successful data fetch',
      build: () {
        when(mockGetTvDetail.execute(tTvId))
            .thenAnswer((_) async => Right(tTvDetail));
        when(mockGetTvRecommendations.execute(tTvId))
            .thenAnswer((_) async => Right(tTvList));
        when(mockGetWatchlistStatusTvs.execute(tTvId))
            .thenAnswer((_) async => false);
        return tvDetailCubit;
      },
      act: (cubit) async => await cubit.fetchTvDetail(tTvId),
      expect: () => [
        TvDetailLoading(),
        TvDetailLoaded(tTvDetail, tTvList, false),
      ],
    );

    blocTest<TvDetailCubit, TvDetailState>(
      'emits [TvDetailLoading, TvDetailError] when TV details fetch fails',
      build: () {
        when(mockGetTvDetail.execute(tTvId)).thenAnswer(
            (_) async => Left(ServerFailure('Failed to fetch movie detail')));
        when(mockGetTvRecommendations.execute(tTvId))
            .thenAnswer((_) async => Right([]));
        when(mockGetWatchlistStatusTvs.execute(tTvId))
            .thenAnswer((_) async => true);
        return tvDetailCubit;
      },
      act: (cubit) async => await cubit.fetchTvDetail(tTvId),
      expect: () => [
        TvDetailLoading(),
        TvDetailError('Failed to fetch movie detail'),
      ],
    );

    blocTest<TvDetailCubit, TvDetailState>(
      'emits [TvDetailLoading, TvDetailError] when TV recommendations fetch fails',
      build: () {
        when(mockGetTvDetail.execute(tTvId))
            .thenAnswer((_) async => Right(tTvDetail));
        when(mockGetTvRecommendations.execute(tTvId)).thenAnswer(
            (_) async => Left(ServerFailure('Recommendations error')));
        when(mockGetWatchlistStatusTvs.execute(tTvId))
            .thenAnswer((_) async => false);
        return tvDetailCubit;
      },
      act: (cubit) async => await cubit.fetchTvDetail(tTvId),
      expect: () => [
        TvDetailLoading(),
        TvDetailLoaded(tTvDetail, [], false),
      ],
    );

    blocTest<TvDetailCubit, TvDetailState>(
      'emits [TvDetailLoading, TvDetailError] when watchlist status fetch fails',
      build: () {
        when(mockGetTvDetail.execute(tTvId))
            .thenAnswer((_) async => Right(tTvDetail));
        when(mockGetTvRecommendations.execute(tTvId)).thenAnswer(
            (_) async => Right(tTvList)); // Mock successful recommendations
        when(mockGetWatchlistStatusTvs.execute(tTvId))
            .thenAnswer((_) async => false); // Mock failure for watchlist
        return tvDetailCubit;
      },
      act: (cubit) async => await cubit.fetchTvDetail(tTvId),
      expect: () =>
          [TvDetailLoading(), TvDetailLoaded(tTvDetail, tTvList, false)],
    );
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/feature/tv/domain/entities/tv_genre.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_watchlist_status_tvs.dart';
import 'package:ditonton/feature/tv/domain/usecases/save_watchlist_tvs.dart';
import 'package:ditonton/feature/tv/domain/usecases/remove_watchlist_tvs.dart';
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
  SaveWatchlistTvs,
  RemoveWatchlistTvs,
])
void main() {
  late TvDetailCubit cubit;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetWatchlistStatusTvs mockGetWatchlistStatusTvs;
  late MockSaveWatchlistTvs mockSaveWatchlistTvs;
  late MockRemoveWatchlistTvs mockRemoveWatchlistTvs;

  const tTvId = 1;
  final tTvDetail = TvDetail(
    adult: false,
    backdropPath: '/path.jpg',
    episodeRunTime: [23],
    firstAirDate: '2015-01-16',
    genres: [
      TvGenre(id: 16, name: 'Animation'),
      TvGenre(id: 35, name: 'Comedy'),
    ],
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
    overview:
        'Tomoya Aki is an otaku who has a dream. His dream is to create the best visual novel game ever. The main heroine for this game and the inspiration for this dream is a background character named Megumi Kato who somehow stumbles into main character-esque traits in his eyes. To complete the game in time he has to call upon the aid of his anime loving professional friends who aren\'t so keen on the choice of his main heroine.',
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
    mockSaveWatchlistTvs = MockSaveWatchlistTvs();
    mockRemoveWatchlistTvs = MockRemoveWatchlistTvs();
    cubit = TvDetailCubit(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
      getWatchListStatus: mockGetWatchlistStatusTvs,
      saveWatchlist: mockSaveWatchlistTvs,
      removeWatchlist: mockRemoveWatchlistTvs,
    );
  });

  group('TvDetailCubit', () {
    blocTest<TvDetailCubit, TvDetailState>(
      'should emit [TvDetailLoading, TvDetailLoaded] when fetching tv details is successful',
      build: () {
        when(mockGetTvDetail.execute(tTvId))
            .thenAnswer((_) async => Right(tTvDetail));
        when(mockGetTvRecommendations.execute(tTvId))
            .thenAnswer((_) async => Right(tTvList));
        when(mockGetWatchlistStatusTvs.execute(tTvId))
            .thenAnswer((_) async => false);
        return cubit;
      },
      act: (cubit) async => await cubit.fetchTvDetail(tTvId),
      expect: () => [
        TvDetailLoading(),
        TvDetailLoaded(tTvDetail, tTvList, false),
      ],
    );

    blocTest<TvDetailCubit, TvDetailState>(
      'should emit [TvDetailWatchlistStatus] when loading watchlist status',
      build: () {
        when(mockGetWatchlistStatusTvs.execute(tTvId))
            .thenAnswer((_) async => true);
        return cubit;
      },
      act: (cubit) async => await cubit.loadWatchlistStatus(tTvId),
      expect: () => [
        TvDetailWatchlistStatus(true, ''),
      ],
    );
  });
}

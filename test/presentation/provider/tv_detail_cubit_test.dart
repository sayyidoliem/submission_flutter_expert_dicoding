import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/feature/tv/domain/entities/tv.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_watchlist_status_tvs.dart';
import 'package:ditonton/feature/tv/domain/usecases/remove_watchlist_tvs.dart';
import 'package:ditonton/feature/tv/domain/usecases/save_watchlist_tvs.dart';
import 'package:ditonton/feature/tv/presentation/provider/tv_detail_cubit/tv_detail_cubit.dart';
import 'package:ditonton/feature/tv/presentation/provider/watchlist_tv_cubit/watchlist_tv_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_cubit_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
  GetWatchlistStatusTvs,
  SaveWatchlistTvs,
  RemoveWatchlistTvs,
])
void main() {
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetWatchlistStatusTvs mockGetWatchlistStatus;
  late MockSaveWatchlistTvs mockSaveWatchlist;
  late MockRemoveWatchlistTvs mockRemoveWatchlist;
  late TvDetailCubit cubit;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetWatchlistStatus = MockGetWatchlistStatusTvs();
    mockSaveWatchlist = MockSaveWatchlistTvs();
    mockRemoveWatchlist = MockRemoveWatchlistTvs();

    cubit = TvDetailCubit(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  final tId = 1;

  void _arrangeUsecase() {
    when(mockGetTvDetail.execute(tId)).thenAnswer((_) async => Right(testTvDetail));
    when(mockGetTvRecommendations.execute(tId)).thenAnswer((_) async => Right(<Tv>[testTv]));
  }

  group('Get Tv Detail', () {
    blocTest<TvDetailCubit, TvDetailState>(
      'should get data from the usecase',
      build: () {
        _arrangeUsecase();
        return cubit;
      },
      act: (cubit) async => await cubit.fetchTvDetail(tId),
      verify: (_) {
        verify(mockGetTvDetail.execute(tId));
        verify(mockGetTvRecommendations.execute(tId));
      },
    );

    blocTest<TvDetailCubit, TvDetailState>(
      'should change state to loading when usecase is called',
      build: () {
        _arrangeUsecase();
        return cubit;
      },
      act: (cubit) async => await cubit.fetchTvDetail(tId),
      expect: () => [isA<TvDetailLoading>()],
    );

    blocTest<TvDetailCubit, TvDetailState>(
      'should change tv when data is gotten successfully',
      build: () {
        _arrangeUsecase();
        return cubit;
      },
      act: (cubit) async => await cubit.fetchTvDetail(tId),
      expect: () => [isA<TvDetailLoaded>()],
    );

    blocTest<TvDetailCubit, TvDetailState>(
      'should return error when data is unsuccessful',
      build: () {
        when(mockGetTvDetail.execute(tId)).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return cubit;
      },
      act: (cubit) async => await cubit.fetchTvDetail(tId),
      expect: () => [isA<TvDetailError>()],
    );
  });

  group('Watchlist', () {
    blocTest<TvDetailCubit, TvDetailState>(
      'should get the watchlist status',
      build: () {
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        return cubit;
      },
      act: (cubit) async => await cubit.loadWatchlistStatus(tId),
      expect: () => [isA<WatchlistTvLoaded>()],
    );

    blocTest<TvDetailCubit, TvDetailState>(
      'should execute save watchlist when function called',
      build: () {
        when(mockSaveWatchlist.execute(testTvDetail)).thenAnswer((_) async => Right('Success'));
        return cubit;
      },
      act: (cubit) async => await cubit.addWatchlist(testTvDetail),
      verify: (_) {
        verify(mockSaveWatchlist.execute(testTvDetail));
      },
    );

    blocTest<TvDetailCubit, TvDetailState>(
      'should execute remove watchlist when function called',
      build: () {
        when(mockRemoveWatchlist.execute(testTvDetail)).thenAnswer((_) async => Right('Removed'));
        return cubit;
      },
      act: (cubit) async => await cubit.removeFromWatchlist(testTvDetail),
      verify: (_) {
        verify(mockRemoveWatchlist.execute(testTvDetail));
      },
    );

    blocTest<TvDetailCubit, TvDetailState>(
      'should update watchlist status when add watchlist success',
      build: () {
        when(mockSaveWatchlist.execute(testTvDetail)).thenAnswer((_) async => Right('Added to Watchlist'));
        return cubit;
      },
      act: (cubit) async => await cubit.addWatchlist(testTvDetail),
      expect: () => [isA<WatchlistTvLoaded>()],
    );

    blocTest<TvDetailCubit, TvDetailState>(
      'should update watchlist message when add watchlist failed',
      build: () {
        when(mockSaveWatchlist.execute(testTvDetail)).thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        return cubit;
      },
      act: (cubit) async => await cubit.addWatchlist(testTvDetail),
      expect: () => [isA<WatchlistTvError>()],
    );
  });
}

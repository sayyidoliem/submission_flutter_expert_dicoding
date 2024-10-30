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
  late TvDetailCubit cubit;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetWatchlistStatusTvs mockGetWatchlistStatus;
  late MockSaveWatchlistTvs mockSaveWatchlist;
  late MockRemoveWatchlistTvs mockRemoveWatchlist;
  
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
    test('should get data from the usecase', () async {
      _arrangeUsecase();
      await cubit.fetchTvDetail(tId);
      verify(mockGetTvDetail.execute(tId));
      verify(mockGetTvRecommendations.execute(tId));
    });

    test('should change state to loading when usecase is called', () async {
      _arrangeUsecase();
      cubit.fetchTvDetail(tId);
      expect(cubit.state, isA<TvDetailLoading>());
    });

    test('should change tv when data is gotten successfully', () async {
      _arrangeUsecase();
      await cubit.fetchTvDetail(tId);
      expect(cubit.state, isA<TvDetailLoaded>());
    });

    test('should return error when data is unsuccessful', () async {
      when(mockGetTvDetail.execute(tId)).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      await cubit.fetchTvDetail(tId);
      expect(cubit.state, isA<TvDetailError>());
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
      await cubit.loadWatchlistStatus(tId);
      expect(cubit.state, isA<WatchlistTvLoaded>());
    });

    test('should execute save watchlist when function called', () async {
      when(mockSaveWatchlist.execute(testTvDetail)).thenAnswer((_) async => Right('Success'));
      await cubit.addWatchlist(testTvDetail);
      verify(mockSaveWatchlist.execute(testTvDetail));
    });

    test('should execute remove watchlist when function called', () async {
      when(mockRemoveWatchlist.execute(testTvDetail)).thenAnswer((_) async => Right('Removed'));
      await cubit.removeFromWatchlist(testTvDetail);
      verify(mockRemoveWatchlist.execute(testTvDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      when(mockSaveWatchlist.execute(testTvDetail)).thenAnswer((_) async => Right('Added to Watchlist'));
      await cubit.addWatchlist(testTvDetail);
      expect(cubit.state, isA<WatchlistTvLoaded>());
    });

    test('should update watchlist message when add watchlist failed', () async {
      when(mockSaveWatchlist.execute(testTvDetail)).thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      await cubit.addWatchlist(testTvDetail);
      expect(cubit.state, isA<WatchlistTvError>());
    });
  });
}


import 'package:ditonton/feature/tv/domain/usecases/get_watchlist_status_tvs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistStatusTvs usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetWatchlistStatusTvs(mockTvRepository);
  });

  test('should get watchlist status from repository', () async {
    // arrange
    when(mockTvRepository.isAddedToWatchlist(1))
        .thenAnswer((_) async => true);
    // act
    final result = await usecase.execute(1);
    // assert
    expect(result, true);
  });
}

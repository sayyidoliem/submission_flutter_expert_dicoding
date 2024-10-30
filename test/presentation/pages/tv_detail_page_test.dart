import 'package:ditonton/feature/tv/domain/entities/tv.dart';
import 'package:ditonton/feature/tv/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/feature/tv/presentation/provider/tv_detail_cubit/tv_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_page_test.mocks.dart';

@GenerateMocks([TvDetailCubit])
void main() {
  late MockTvDetailCubit mockCubit;

  setUp(() {
    mockCubit = MockTvDetailCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvDetailCubit>.value(
      value: mockCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when tv not added to watchlist',
      (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(TvDetailLoaded( testTvDetail,  <Tv>[], false,));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when tv is added to watchlist',
      (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(TvDetailLoaded(testTvDetail,  <Tv>[], false,));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(TvDetailLoaded(testTvDetail,  <Tv>[], false,));
    when(mockCubit.addWatchlist(testTvDetail)).thenAnswer((_) async {
      // Simulate adding to watchlist
      when(mockCubit.state).thenReturn(TvDetailLoaded(testTvDetail,  <Tv>[], false,));
    });

    final watchlistButton = find.byType(FilledButton);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(TvDetailLoaded(testTvDetail,  <Tv>[], false,));
    when(mockCubit.addWatchlist(testTvDetail)).thenAnswer((_) async {
      // Simulate failure
      when(mockCubit.state).thenReturn(TvDetailError( 'Failed'));
    });

    final watchlistButton = find.byType(FilledButton);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}


import 'package:ditonton/feature/movie/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/feature/movie/presentation/provider/movie_detail_cubit/movie_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_page_test.mocks.dart';

@GenerateMocks([MovieDetailCubit])
void main() {
  late MockMovieDetailCubit mockCubit;

  setUp(() {
    mockCubit = MockMovieDetailCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailCubit>.value(
      value: mockCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  final movieDetailLoadedState = MovieDetailLoaded(
    testMovieDetail,
    [], // empty recommendations
    false, // not added to watchlist
  );

  testWidgets(
    'Watchlist button should display add icon when movie not added to watchlist',
    (WidgetTester tester) async {
      when(mockCubit.state).thenReturn(movieDetailLoadedState);

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when movie is added to watchlist',
    (WidgetTester tester) async {
      when(mockCubit.state).thenReturn(movieDetailLoadedState.copyWith(isAddedToWatchlist: true));

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (WidgetTester tester) async {
      when(mockCubit.state).thenReturn(movieDetailLoadedState);

      final watchlistButton = find.byType(FilledButton);

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);

      // Simulate adding to watchlist
      when(mockCubit.addWatchlist(testMovieDetail)).thenAnswer((_) async {
        when(mockCubit.state).thenReturn(movieDetailLoadedState.copyWith(isAddedToWatchlist: true));
      });

      await tester.tap(watchlistButton);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added to Watchlist'), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
    (WidgetTester tester) async {
      when(mockCubit.state).thenReturn(movieDetailLoadedState);

      final watchlistButton = find.byType(FilledButton);

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);

      // Simulate adding to watchlist failure
      when(mockCubit.addWatchlist(testMovieDetail)).thenAnswer((_) async {
        when(mockCubit.state).thenReturn(MovieDetailError('Failed'));
      });

      await tester.tap(watchlistButton);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    },
  );
}

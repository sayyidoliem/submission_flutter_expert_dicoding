import 'package:ditonton/common/constants.dart';
import 'package:ditonton/feature/movie/presentation/pages/about_page.dart';
import 'package:ditonton/feature/movie/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/feature/movie/presentation/pages/home_movie_page.dart';
import 'package:ditonton/feature/movie/presentation/pages/now_play_movies_page.dart';
import 'package:ditonton/feature/movie/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/feature/movie/presentation/pages/search_movies_page.dart';
import 'package:ditonton/feature/movie/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/feature/movie/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/feature/movie/presentation/provider/movie_detail_cubit/movie_detail_cubit.dart';
import 'package:ditonton/feature/movie/presentation/provider/movie_list_cubit/movie_list_cubit.dart';
import 'package:ditonton/feature/movie/presentation/provider/movie_search_cubit/movie_search_cubit.dart';
import 'package:ditonton/feature/movie/presentation/provider/now_play_movie_cubit/now_play_movie_cubit.dart';
import 'package:ditonton/feature/movie/presentation/provider/popular_movie_cubit/popular_movie_cubit.dart';
import 'package:ditonton/feature/movie/presentation/provider/top_rated_movie_cubit/top_rated_movie_cubit.dart';
import 'package:ditonton/feature/movie/presentation/provider/watchlist_movie_cubit/watchlist_movie_cubit.dart';
import 'package:ditonton/feature/tv/presentation/pages/home_tv_page.dart';
import 'package:ditonton/feature/tv/presentation/pages/now_play_tv_page.dart';
import 'package:ditonton/feature/tv/presentation/pages/popular_tv_page.dart';
import 'package:ditonton/feature/tv/presentation/pages/search_tv_page.dart';
import 'package:ditonton/feature/tv/presentation/pages/top_rated_tv_page.dart';
import 'package:ditonton/feature/tv/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/feature/tv/presentation/pages/watchlist_tv_page.dart';
import 'package:ditonton/feature/tv/presentation/provider/now_play_tvs_cubit/now_play_tvs_cubit.dart';
import 'package:ditonton/feature/tv/presentation/provider/popular_tvs_cubit/popular_tvs_cubit.dart';
import 'package:ditonton/feature/tv/presentation/provider/top_rated_tvs_cubit/top_rated_tvs_cubit.dart';
import 'package:ditonton/feature/tv/presentation/provider/tv_detail_cubit/tv_detail_cubit.dart';
import 'package:ditonton/feature/tv/presentation/provider/tv_list_cubit/tv_list_cubit.dart';
import 'package:ditonton/feature/tv/presentation/provider/tv_search_cubit/tv_search_cubit.dart';
import 'package:ditonton/feature/tv/presentation/provider/watchlist_tv_cubit/watchlist_tv_cubit.dart';
import 'package:ditonton/firebase_options.dart';
import 'package:ditonton/utils/route_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<MovieListCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieDetailCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieSearchCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<NowPlayingMoviesCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedMoviesCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularMoviesCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistMoviesCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvListCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvDetailCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvSearchCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedTvsCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<NowPlayingTvsCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularTvsCubit>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistTvCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(
                builder: (_) => HomeMoviePage(),
                settings: settings,
              );
            case HomeTvPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => HomeTvPage());
            case NowPlayMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => NowPlayMoviesPage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                builder: (_) => SearchMoviesPage(),
                settings: settings,
              );
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case NowPlayTvsPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => NowPlayTvsPage());
            case PopularTvsPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularTvsPage());
            case TopRatedTvsPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedTvsPage());
            case TvDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvDetailPage(id: id),
                settings: settings,
              );
            case SearchTvsPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchTvsPage());
            case WatchlistTvsPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistTvsPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(
                builder: (_) {
                  return Scaffold(
                    body: Center(
                      child: Text('Page not found :('),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}

import 'package:ditonton/feature/movie/data/datasources/db/movie_database_helper.dart';
import 'package:ditonton/feature/movie/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/feature/movie/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/feature/movie/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/feature/movie/domain/repositories/movie_repository.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_watchlist_status_movies.dart';
import 'package:ditonton/feature/movie/domain/usecases/remove_watchlist_movies.dart';
import 'package:ditonton/feature/movie/domain/usecases/save_watchlist_movies.dart';
import 'package:ditonton/feature/movie/domain/usecases/search_movies.dart';
import 'package:ditonton/feature/movie/presentation/provider/movie_detail_cubit/movie_detail_cubit.dart';
import 'package:ditonton/feature/movie/presentation/provider/movie_list_cubit/movie_list_cubit.dart';
import 'package:ditonton/feature/movie/presentation/provider/movie_search_cubit/movie_search_cubit.dart';
import 'package:ditonton/feature/movie/presentation/provider/popular_movie_cubit/popular_movie_cubit.dart';
import 'package:ditonton/feature/movie/presentation/provider/top_rated_movie_cubit/top_rated_movie_cubit.dart';
import 'package:ditonton/feature/movie/presentation/provider/watchlist_movie_cubit/watchlist_movie_cubit.dart';
import 'package:ditonton/feature/tv/data/datasources/db/tv_database_helper.dart';
import 'package:ditonton/feature/tv/data/datasources/tv_local_data_source.dart';
import 'package:ditonton/feature/tv/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/feature/tv/data/repositories/tv_repository_impl.dart';
import 'package:ditonton/feature/tv/domain/repositories/tv_repository.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_now_playing_tvs.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_popular_tvs.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_watchlist_status_tvs.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_watchlist_tvs.dart';
import 'package:ditonton/feature/tv/domain/usecases/remove_watchlist_tvs.dart';
import 'package:ditonton/feature/tv/domain/usecases/save_watchlist_tvs.dart';
import 'package:ditonton/feature/tv/domain/usecases/search_tvs.dart';
import 'package:ditonton/feature/tv/presentation/provider/now_play_tvs_cubit/now_play_tvs_cubit.dart';
import 'package:ditonton/feature/tv/presentation/provider/popular_tvs_cubit/popular_tvs_cubit.dart';
import 'package:ditonton/feature/tv/presentation/provider/top_rated_tvs_cubit/top_rated_tvs_cubit.dart';
import 'package:ditonton/feature/tv/presentation/provider/tv_detail_cubit/tv_detail_cubit.dart';
import 'package:ditonton/feature/tv/presentation/provider/tv_list_cubit/tv_list_cubit.dart';
import 'package:ditonton/feature/tv/presentation/provider/tv_search_cubit/tv_search_cubit.dart';
import 'package:ditonton/feature/tv/presentation/provider/watchlist_tv_cubit/watchlist_tv_cubit.dart';
import 'package:ditonton/utils/ssl_certified_client.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  // provider movie
  locator.registerFactory(
    () => MovieListCubit(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailCubit(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieSearchCubit(
      searchMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMoviesCubit(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesCubit(
      locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMoviesCubit(
      getWatchlistMovies: locator(),
    ),
  );

  //provider tv
  locator.registerFactory(
    () => TvListCubit(
      getNowPlayingTvs: locator(),
      getPopularTvs: locator(),
      getTopRatedTvs: locator(),
    ),
  );
  locator.registerFactory(
    () => TvDetailCubit(
      getTvDetail: locator(),
      getTvRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSearchCubit(
      searchTvs: locator(),
    ),
  );
  locator.registerFactory(
    () => NowPlayingTvsCubit(
      getNowPlayingTvs: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularTvsCubit(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedTvsCubit(
      locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistTvCubit(
      getWatchlistTvs: locator(),
    ),
  );

  // use case movie
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusMovies(locator()));
  locator.registerLazySingleton(() => SaveWatchlistMovies(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistMovies(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  //use case tv
  locator.registerLazySingleton(() => GetNowPlayingTvs(locator()));
  locator.registerLazySingleton(() => GetPopularTvs(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvs(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTvs(locator()));
  locator.registerLazySingleton(() => GetWatchlistStatusTvs(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTvs(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTvs(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvs(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<TvRemoteDataSource>(
      () => TvRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvLocalDataSource>(
      () => TvLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator
      .registerLazySingleton<MovieDatabaseHelper>(() => MovieDatabaseHelper());
  locator.registerLazySingleton<TvDatabaseHelper>(() => TvDatabaseHelper());

  // external
  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton<SSLCertifiedClient>(
    () => SSLCertifiedClient(),
  );
}

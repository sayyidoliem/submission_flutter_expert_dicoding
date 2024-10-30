import 'package:ditonton/feature/movie/data/datasources/db/movie_database_helper.dart';
import 'package:ditonton/feature/movie/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/feature/movie/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/feature/movie/domain/repositories/movie_repository.dart';
import 'package:ditonton/feature/tv/data/datasources/db/tv_database_helper.dart';
import 'package:ditonton/feature/tv/data/datasources/tv_local_data_source.dart';
import 'package:ditonton/feature/tv/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/feature/tv/domain/repositories/tv_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  MovieDatabaseHelper,
  TvRepository,
  TvRemoteDataSource,
  TvLocalDataSource,
  TvDatabaseHelper,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}

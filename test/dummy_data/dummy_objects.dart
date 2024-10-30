import 'package:ditonton/feature/movie/data/models/movie_table.dart';
import 'package:ditonton/feature/movie/domain/entities/movie_genre.dart';
import 'package:ditonton/feature/movie/domain/entities/movie.dart';
import 'package:ditonton/feature/movie/domain/entities/movie_detail.dart';
import 'package:ditonton/feature/tv/data/models/tv_table.dart';
import 'package:ditonton/feature/tv/domain/entities/tv.dart';
import 'package:ditonton/feature/tv/domain/entities/tv_detail.dart';
import 'package:ditonton/feature/tv/domain/entities/tv_genre.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [MovieGenre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testTv = Tv(
  adult: false,
  backdropPath: "/3HvXeJzSztADlAua3l4gjawVhPC.jpg",
  genreIds: [16, 35],
  id: 69367,
  originalName: "冴えない彼女の育てかた",
  overview:
      "Tomoya Aki is an otaku who has a dream. His dream is to create the best visual novel game ever. The main heroine for this game and the inspiration for this dream is a background character named Megumi Kato who somehow stumbles into main character-esque traits in his eyes. To complete the game in time he has to call upon the aid of his anime loving professional friends who aren't so keen on the choice of his main heroine.",
  popularity: 63.749,
  posterPath: "/GP7I1yKTp6giJz2fdy0LBWo4zV.jpg",
  firstAirDate: "2015-01-16",
  name: "Saekano: How to Raise a Boring Girlfriend",
  voteAverage: 6.7,
  voteCount: 68,
);

final testTvList = [testTv];

final testTvDetail = TvDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [
    TvGenre(id: 1, name: 'Action'),
  ],
  id: 1,
  overview: 'overview',
  posterPath: 'posterPath',
  voteAverage: 1,
  voteCount: 1,
  episodeRunTime: [
    10,
    20,
    30,
  ],
  firstAirDate: 'firstAirDate',
  homepage: 'homePage',
  inProduction: false,
  languages: ['jp'],
  lastAirDate: 'lastAirDate',
  name: 'name',
  numberOfEpisodes: 10,
  numberOfSeasons: 10,
  originCountry: ['jp'],
  originalLanguage: 'originalLanguange',
  originalName: 'originalName',
  popularity: 1.0,
  status: 'status',
  tagline: 'tagline',
);

final testWatchlistTv = Tv.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvTable = TvTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};

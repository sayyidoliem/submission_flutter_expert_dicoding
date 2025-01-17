import 'package:ditonton/feature/movie/presentation/provider/now_play_movie_cubit/now_play_movie_cubit.dart';
import 'package:ditonton/feature/movie/presentation/provider/now_play_movie_cubit/now_play_movie_state.dart';
import 'package:ditonton/feature/movie/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NowPlayMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/nowplay-movie';

  @override
  _NowPlayMoviesPageState createState() => _NowPlayMoviesPageState();
}

class _NowPlayMoviesPageState extends State<NowPlayMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<NowPlayingMovieCubit>().fetchNowPlayingMovie());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Play Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<NowPlayingMovieCubit, NowPlayingMovieState>(
          builder: (context, state) {
            if (state is NowPlayingMovieLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is NowPlayingMovieLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.movie[index];
                  return MovieCard(movie);
                },
                itemCount: state.movie.length,
              );
            } else if (state is NowPlayingMovieError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return const Center(child: Text('No data available.'));
            }
          },
        ),
      ),
    );
  }
}

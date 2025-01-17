import 'package:bloc/bloc.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/feature/movie/presentation/provider/now_play_movie_cubit/now_play_movie_state.dart';

class NowPlayingMovieCubit extends Cubit<NowPlayingMovieState> {
  final GetNowPlayingMovies getNowPlayingMovie;

  NowPlayingMovieCubit(this.getNowPlayingMovie)
      : super(NowPlayingMovieInitial());

  Future<void> fetchNowPlayingMovie() async {
    emit(NowPlayingMovieLoading());

    final result = await getNowPlayingMovie.execute();
    result.fold(
      (failure) {
        emit(NowPlayingMovieError(failure.message));
      },
      (MovieData) {
        emit(NowPlayingMovieLoaded(MovieData));
      },
    );
  }
}

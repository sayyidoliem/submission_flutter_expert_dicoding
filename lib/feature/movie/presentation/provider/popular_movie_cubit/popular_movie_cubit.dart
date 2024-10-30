import 'package:bloc/bloc.dart';
import 'package:ditonton/feature/movie/domain/entities/movie.dart';
import 'package:ditonton/feature/movie/domain/usecases/get_popular_movies.dart';
import 'package:equatable/equatable.dart';

part 'popular_movie_state.dart';

class PopularMoviesCubit extends Cubit<PopularMoviesState> {
  final GetPopularMovies getPopularMovies;

  PopularMoviesCubit(this.getPopularMovies) : super(PopularMoviesInitial());

  Future<void> fetchPopularMovies() async {
    emit(PopularMoviesLoading());

    final result = await getPopularMovies.execute();
    
    result.fold(
      (failure) {
        emit(PopularMoviesError(failure.message));
      },
      (moviesData) {
        emit(PopularMoviesLoaded(moviesData));
      },
    );
  }
}

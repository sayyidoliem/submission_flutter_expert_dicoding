import 'package:bloc/bloc.dart';
import 'package:ditonton/feature/tv/domain/entities/tv.dart';
import 'package:ditonton/feature/tv/domain/usecases/get_now_playing_tvs.dart';
import 'package:equatable/equatable.dart';

part 'now_play_tvs_state.dart';

class NowPlayingTvsCubit extends Cubit<NowPlayingTvsState> {
  final GetNowPlayingTvs getNowPlayingTvs;

  NowPlayingTvsCubit({required this.getNowPlayingTvs})
      : super(NowPlayingTvsInitial());

  Future<void> fetchNowPlayingTvs() async {
    emit(NowPlayingTvsLoading());

    final result = await getNowPlayingTvs.execute();
    result.fold(
      (failure) {
        emit(NowPlayingTvsError(failure.message));
      },
      (tvsData) {
        emit(NowPlayingTvsLoaded(tvsData));
      },
    );
  }
}

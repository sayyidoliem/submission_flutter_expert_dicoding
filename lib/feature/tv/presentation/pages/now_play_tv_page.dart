import 'package:ditonton/feature/tv/presentation/provider/now_play_tvs_cubit/now_play_tvs_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/feature/tv/presentation/widgets/tv_card_list.dart';

class NowPlayTvsPage extends StatefulWidget {
  static const ROUTE_NAME = '/nowplay-tv';

  @override
  _NowPlayTvsPageState createState() => _NowPlayTvsPageState();
}

class _NowPlayTvsPageState extends State<NowPlayTvsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<NowPlayingTvsCubit>().fetchNowPlayingTvs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Playing TVs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<NowPlayingTvsCubit, NowPlayingTvsState>(
          builder: (context, state) {
            if (state is NowPlayingTvsLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is NowPlayingTvsLoaded) {
              return ListView.builder(
                itemCount: state.nowPlayingTvs.length,
                itemBuilder: (context, index) {
                  final tv = state.nowPlayingTvs[index];
                  return TvCard(tv);
                },
              );
            } else if (state is NowPlayingTvsError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Center(
                child: Text('No data available.'),
              );
            }
          },
        ),
      ),
    );
  }
}

import 'package:ditonton/common/utils.dart';
import 'package:ditonton/feature/tv/presentation/provider/watchlist_tv_cubit/watchlist_tv_cubit.dart';
import 'package:ditonton/feature/tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistTvsPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-tv';

  @override
  _WatchlistTvsPageState createState() => _WatchlistTvsPageState();
}

class _WatchlistTvsPageState extends State<WatchlistTvsPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    // Fetch watchlist TV shows when the page is initialized
    Future.microtask(() =>
        context.read<WatchlistTvCubit>().fetchWatchlistTvs());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context.read<WatchlistTvCubit>().fetchWatchlistTvs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistTvCubit, WatchlistTvState>(
          builder: (context, state) {
            if (state is WatchlistTvLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is WatchlistTvLoaded) {
              return ListView.builder(
                itemCount: state.watchlistTvs.length,
                itemBuilder: (context, index) {
                  final tv = state.watchlistTvs[index];
                  return TvCard(tv);
                },
              );
            } else if (state is WatchlistTvError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Center(child: Text('No watchlist available.'));
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}

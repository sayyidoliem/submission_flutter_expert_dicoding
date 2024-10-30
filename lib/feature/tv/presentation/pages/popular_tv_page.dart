import 'package:ditonton/feature/tv/presentation/provider/popular_tvs_cubit/popular_tvs_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/feature/tv/presentation/widgets/tv_card_list.dart';

class PopularTvsPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv';

  @override
  _PopularTvsPageState createState() => _PopularTvsPageState();
}

class _PopularTvsPageState extends State<PopularTvsPage> {
  @override
  void initState() {
    super.initState();
    // Fetch popular TVs when the widget is initialized
    context.read<PopularTvsCubit>().fetchPopularTvs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular TVs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTvsCubit, PopularTvsState>(
          builder: (context, state) {
            if (state is PopularTvsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PopularTvsLoaded) {
              return ListView.builder(
                itemCount: state.tvs.length,
                itemBuilder: (context, index) {
                  final tv = state.tvs[index];
                  return TvCard(tv);
                },
              );
            } else if (state is PopularTvsError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Center(child: Text('No data available.'));
            }
          },
        ),
      ),
    );
  }
}

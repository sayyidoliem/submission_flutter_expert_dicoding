import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/feature/tv/domain/entities/tv.dart';
import 'package:ditonton/feature/tv/presentation/pages/now_play_tv_page.dart';
import 'package:ditonton/feature/tv/presentation/pages/popular_tv_page.dart';
import 'package:ditonton/feature/tv/presentation/pages/search_tv_page.dart';
import 'package:ditonton/feature/tv/presentation/pages/top_rated_tv_page.dart';
import 'package:ditonton/feature/tv/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/feature/tv/presentation/provider/now_play_tvs_cubit/now_play_tvs_cubit.dart';
import 'package:ditonton/feature/tv/presentation/provider/popular_tvs_cubit/popular_tvs_cubit.dart';
import 'package:ditonton/feature/tv/presentation/provider/tv_list_cubit/tv_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv';
  const HomeTvPage({super.key});

  @override
  State<HomeTvPage> createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvListCubit>().fetchTopRatedTvs(); 
      context.read<NowPlayingTvsCubit>().fetchNowPlayingTvs(); 
      context.read<PopularTvsCubit>().fetchPopularTvs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchTvsPage.ROUTE_NAME);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubHeading(
                title: 'Now Playing',
                onTap: () =>
                    Navigator.pushNamed(context, NowPlayTvsPage.ROUTE_NAME),
              ),
              BlocBuilder<NowPlayingTvsCubit, NowPlayingTvsState>(
                builder: (context, state) {
                  if (state is NowPlayingTvsLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is NowPlayingTvsLoaded) {
                    return TvList(state.nowPlayingTvs);
                  } else {
                    return Text('Failed to load');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularTvsPage.ROUTE_NAME),
              ),
              BlocBuilder<PopularTvsCubit, PopularTvsState>(
                builder: (context, state) {
                  if (state is PopularTvsLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is PopularTvsLoaded) {
                    return TvList(state.tvs);
                  } else {
                    return Text('Failed to load');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedTvsPage.ROUTE_NAME),
              ),
              BlocBuilder<TvListCubit, TvListState>(
                builder: (context, state) {
                  if (state is TvListLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is TopRatedTvListLoaded) {
                    return TvList(state.topRatedTvs);
                  } else {
                    return Text('Failed to load');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: kHeading6),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TvList extends StatelessWidget {
  final List<Tv> tvs;

  TvList(this.tvs);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tvs.length,
        itemBuilder: (context, index) {
          final tv = tvs[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvDetailPage.ROUTE_NAME,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/feature/tv/domain/entities/tv_genre.dart';
import 'package:ditonton/feature/tv/domain/entities/tv.dart';
import 'package:ditonton/feature/tv/domain/entities/tv_detail.dart';
import 'package:ditonton/feature/tv/presentation/provider/tv_detail_cubit/tv_detail_cubit.dart';
import 'package:ditonton/feature/tv/presentation/provider/watchlist_tv_cubit/watchlist_tv_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv/detail';

  final int id;
  TvDetailPage({required this.id});

  @override
  _TvDetailPageState createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvDetailCubit>().fetchTvDetail(widget.id);
      context.read<WatchlistTvCubit>().loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvDetailCubit, TvDetailState>(
        builder: (context, state) {
          if (state is TvDetailLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TvDetailLoaded) {
            return SafeArea(
              child: DetailContent(
                state.tv,
                state.recommendations,
                state.isAddedToWatchlist,
              ),
            );
          } else if (state is TvDetailError) {
            return Center(child: Text(state.message));
          }
          return Container(); // Fallback for other states
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvDetail tv;
  final List<Tv> recommendations;
  final bool isAddedWatchlist;

  DetailContent(this.tv, this.recommendations, this.isAddedWatchlist);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocListener<WatchlistTvCubit, WatchlistTvState>(
      listener: (context, state) {
        if (state is TvWatchlistStatusState) {
                  ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.message)));
        }

      },
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
            width: screenWidth,
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Container(
            margin: const EdgeInsets.only(top: 56),
            child: DraggableScrollableSheet(
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: kRichBlack,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tv.name ?? 'title', style: kHeading5),
                        FilledButton(
                          onPressed: () async {
                            final cubit = context.read<WatchlistTvCubit>();
                            if (!isAddedWatchlist) {
                              await cubit.addWatchlist(tv);
                            } else {
                              await cubit.removeFromWatchlist(tv);
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              isAddedWatchlist
                                  ? Icon(Icons.check)
                                  : Icon(Icons.add),
                              Text('Watchlist'),
                            ],
                          ),
                        ),
                        Text(_showGenres(tv.genres)),
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: tv.voteAverage ?? 0 / 2,
                              itemCount: 5,
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: kMikadoYellow,
                              ),
                              itemSize: 24,
                            ),
                            Text('${tv.voteAverage}')
                          ],
                        ),
                        SizedBox(height: 16),
                        Text('Overview', style: kHeading6),
                        Text(tv.overview ?? 'overview'),
                        SizedBox(height: 16),
                        Text('Recommendations', style: kHeading6),
                        _buildRecommendations(context),
                      ],
                    ),
                  ),
                );
              },
              minChildSize: 0.25,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: kRichBlack,
              foregroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations(BuildContext context) {
    return BlocBuilder<TvDetailCubit, TvDetailState>(
      builder: (context, state) {
        if (state is TvDetailLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is TvDetailError) {
          return Text(state.message);
        } else if (state is TvDetailLoaded) {
          return Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                final tv = recommendations[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        TvDetailPage.ROUTE_NAME,
                        arguments: tv.id,
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://image.tmdb.org/t/p/w500${tv.posterPath}',
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
        return Container(); // Fallback for other states
      },
    );
  }

  String _showGenres(List<TvGenre> genres) {
    return genres.map((genre) => genre.name).join(', ');
  }
}

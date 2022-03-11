import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ten_twenty/models/Genre.dart';
import 'package:ten_twenty/models/UpcomingMovieResponse.dart';
import 'package:ten_twenty/notifiers/HomeScreenController.dart';
import 'package:ten_twenty/notifiers/MovieListController.dart';
import 'package:ten_twenty/theme/ThemeNotifier.dart';
import 'package:ten_twenty/ui/MovieDetailed.dart';
import 'package:ten_twenty/widgets/MediaItem.dart';

class ScreenWatch extends StatelessWidget {
  late MovieListController movieListController;

  @override
  Widget build(BuildContext context) {
    movieListController = Provider.of<MovieListController>(context);
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),
            if (movieListController.upcomingMovieResponse == null) ...[
              AspectRatio(aspectRatio: 1, child: Center(child: CircularProgressIndicator())),
            ] else if (movieListController.upcomingMovieResponse!.results == null) ...[
              AspectRatio(aspectRatio: 1, child: Center(child: Text('Unable to load movies data', textAlign: TextAlign.center)))
            ] else ...[
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  Results result = movieListController.upcomingMovieResponse!.results![index];
                  return GestureDetector(
                    child: MediaItem(EdgeInsets.symmetric(horizontal: 20, vertical: 10), result),
                    onTap: () {
                      movieListController.setSelected(result);
                      Navigator.pushNamed(context, MovieDetailedScreen.Route);
                    },
                  );
                },
                itemCount: movieListController.upcomingMovieResponse!.results!.length,
              )
            ],
          ],
        ),
      ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  late HomeScreenController homeScreenController;
  late MovieListController movieListController;

  @override
  Widget build(BuildContext context) {
    homeScreenController = Provider.of<HomeScreenController>(context);
    movieListController = Provider.of<MovieListController>(context);
    return Container(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (homeScreenController.searchController.text.isNotEmpty && homeScreenController.submitted == false && homeScreenController.searchedResults(context).isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), child: Text('Top Results')),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0), child: Divider(height: 1)),
              const SizedBox(height: 12),
            ],
            if (homeScreenController.searchController.text.isEmpty) ...[
              if (movieListController.movieGenres != null) ...[
                GridView.builder(
                  itemCount: movieListController.movieGenres!.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 16 / 10,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (_, index) {
                    Genre genre = movieListController.movieGenres![index];
                    return MediaItem(EdgeInsets.symmetric(horizontal: 8, vertical: 5), null, genre: genre);
                  },
                ),
              ] else ...[
                Center(
                  child: Theme(
                    child: CircularProgressIndicator(),
                    data: Theme.of(context).copyWith(colorScheme: Theme.of(context).colorScheme.copyWith(primary: AppThemeNotifier.definedColor4)),
                  ),
                ),
              ]
            ] else ...[
              Builder(
                builder: (_) {
                  List<Results> searched = homeScreenController.searchedResults(context);
                  return ListView.builder(
                    itemCount: searched.length,
                    itemBuilder: (_, index) {
                      Results result = searched[index];
                      return Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(AppThemeNotifier.inputBorderRadius),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppThemeNotifier.inputBorderRadius),
                          onTap: () => {
                            movieListController.setSelected(result),
                            Navigator.pushNamed(context, MovieDetailedScreen.Route),
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 120,
                                  height: 95,
                                  child: ClipRRect(
                                    child: Image.network(
                                      movieListController.generateMoviePoster(result.posterPath), // 'https://cdn.mos.cms.futurecdn.net/fM7oKQDCKpgMuobZpFwRgK.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(AppThemeNotifier.inputBorderRadius),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        result.title!,
                                        style: Theme.of(context).textTheme.button!.copyWith(
                                              fontSize: Theme.of(context).textTheme.button!.fontSize! + 2,
                                            ),
                                      ),
                                      Text(movieListController.genreById(result.genreIds!.first), style: Theme.of(context).textTheme.caption),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz, color: Color(0x0ff61C3F2)), splashRadius: 24),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

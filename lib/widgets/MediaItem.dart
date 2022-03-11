import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ten_twenty/models/Genre.dart';
import 'package:ten_twenty/models/UpcomingMovieResponse.dart';
import 'package:ten_twenty/notifiers/MovieListController.dart';
import 'package:ten_twenty/theme/ThemeNotifier.dart';

class MediaItem extends StatelessWidget {
  late MovieListController movieListController;
  EdgeInsets edgeInsets;
  Results? result;
  Genre? genre;

  MediaItem(this.edgeInsets, this.result, {this.genre});

  @override
  Widget build(BuildContext context) {
    movieListController = Provider.of<MovieListController>(context, listen: false);
    return Container(
      child: Padding(
        padding: edgeInsets,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppThemeNotifier.inputBorderRadius),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    genre != null ? movieListController.generateRandomPoster() : movieListController.generateMoviePoster(result != null ? result!.posterPath : null),
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black26,
                        Colors.black87,
                      ],
                      tileMode: TileMode.decal,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                      child: Text(
                        genre != null
                            ? genre!.title
                            : result != null
                                ? result!.title!
                                : 'Free Guy',
                        style: genre != null
                            ? Theme.of(context).textTheme.button!.copyWith(
                                  color: Theme.of(context).colorScheme.onSecondary,
                                )
                            : Theme.of(context).textTheme.headline6!.copyWith(
                                  color: Theme.of(context).colorScheme.onSecondary,
                                ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

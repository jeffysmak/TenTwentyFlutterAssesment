import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:ten_twenty/models/VimeoVideo.dart';
import 'package:ten_twenty/notifiers/HomeScreenController.dart';
import 'package:ten_twenty/notifiers/MovieListController.dart';
import 'package:ten_twenty/theme/ThemeNotifier.dart';
import 'package:ten_twenty/ui/PlayerScreen.dart';
import 'package:ten_twenty/ui/SeatsAvailableScreen.dart';
import 'package:ten_twenty/widgets/Buttons.dart';

class MovieDetailedScreen extends StatelessWidget {
  static const Route = '/MovieDetailedScreen';
  late AppThemeNotifier appThemeNotifier;

  @override
  Widget build(BuildContext context) {
    appThemeNotifier = Provider.of<AppThemeNotifier>(context);
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return appThemeNotifier.isScreenWider ? LandscapeScreenViw() : PortraitScreenView();
        },
      ),
    );
  }
}

class PortraitScreenView extends StatelessWidget {
  late HomeScreenController homeScreenController;
  late MovieListController movieListController;

  @override
  Widget build(BuildContext context) {
    movieListController = Provider.of<MovieListController>(context);
    homeScreenController = Provider.of<HomeScreenController>(context);
    return Container(
      child: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  movieListController.generateMoviePoster(
                                    movieListController.selectedMovieDetailed != null ? movieListController.selectedMovieDetailed!.posterPath : null,
                                  ),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.black12,
                                  Colors.black87,
                                ],
                                tileMode: TileMode.decal,
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(AppThemeNotifier.inputBorderRadius),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(AppThemeNotifier.inputBorderRadius),
                                onTap: () => Navigator.pop(context),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(width: 8),
                                    IconButton(onPressed: null, icon: Icon(Icons.arrow_back_ios, color: Colors.white)),
                                    Text(
                                      homeScreenController.screenTitles[homeScreenController.currentScreenIndex],
                                      style: Theme.of(context).textTheme.button!.copyWith(fontSize: 16, color: Colors.white),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                                child: Text(
                                  movieListController.generateInTheater(),
                                  style: Theme.of(context).textTheme.headline6!.copyWith(
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 56.0, vertical: 8),
                                child: OutlineThemedButton(
                                  onTap: () => Navigator.pushNamed(context, SeatsAvailableScreen.Route),
                                  title: 'Get Tickets',
                                  color: AppThemeNotifier.definedColor4,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 56.0, vertical: 8),
                                child: OutlineThemedButton(
                                  onTap: () {
                                    BotToast.showText(text: 'Video uri is not present in api, so using a dummy video URI from network', duration: Duration(seconds: 5));
                                    Navigator.pushNamed(context, PlayerScreen.Route);
                                  },
                                  title: 'Watch',
                                  iconData: Ionicons.play,
                                  color: Colors.transparent,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(children: [Text('Genres', style: Theme.of(context).textTheme.headline6), Spacer()]),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Wrap(
                            children: movieListController.selectedMovieDetailed!.genreIds!
                                .map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4),
                                    child: Chip(
                                      label: Text(movieListController.genreById(e),
                                          style: Theme.of(context).textTheme.button!.copyWith(color: Theme.of(context).colorScheme.primary)),
                                      backgroundColor: AppThemeNotifier.colors[new Random().nextInt(AppThemeNotifier.colors.length)],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8), child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(children: [Text('Overview', style: Theme.of(context).textTheme.headline6), Spacer()]),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            movieListController.movieOverview,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (movieListController.busy) ...[
            Align(alignment: Alignment.center, child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }
}

class LandscapeScreenViw extends StatelessWidget {
  late HomeScreenController homeScreenController;
  late MovieListController movieListController;

  @override
  Widget build(BuildContext context) {
    homeScreenController = Provider.of<HomeScreenController>(context);
    movieListController = Provider.of<MovieListController>(context);
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 50,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            movieListController.generateMoviePoster(
                              movieListController.selectedMovieDetailed != null ? movieListController.selectedMovieDetailed!.posterPath : null,
                            ),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black12,
                            Colors.black87,
                          ],
                          tileMode: TileMode.decal,
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(AppThemeNotifier.inputBorderRadius),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppThemeNotifier.inputBorderRadius),
                          onTap: () => Navigator.pop(context),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 8),
                              IconButton(onPressed: null, icon: Icon(Icons.arrow_back_ios, color: Colors.white)),
                              Text(
                                homeScreenController.screenTitles[homeScreenController.currentScreenIndex],
                                style: Theme.of(context).textTheme.button!.copyWith(fontSize: 16, color: Colors.white),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            movieListController.generateInTheater(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline6!.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlineThemedButton(
                                  onTap: () => Navigator.pushNamed(context, SeatsAvailableScreen.Route),
                                  title: 'Get Tickets',
                                  color: AppThemeNotifier.definedColor4,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlineThemedButton(
                                  onTap: () {
                                    BotToast.showText(text: 'Video uri is not present in api, so using a dummy video URI from network', duration: Duration(seconds: 5));
                                    Navigator.pushNamed(context, PlayerScreen.Route);
                                  },
                                  title: 'Watch',
                                  iconData: Ionicons.play,
                                  color: Colors.transparent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 55,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(children: [Text('Genres', style: Theme.of(context).textTheme.headline6), Spacer()]),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Wrap(
                      children: movieListController.selectedMovieDetailed!.genreIds!
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4),
                              child: Chip(
                                label:
                                    Text(movieListController.genreById(e), style: Theme.of(context).textTheme.button!.copyWith(color: Theme.of(context).colorScheme.primary)),
                                backgroundColor: AppThemeNotifier.colors[new Random().nextInt(AppThemeNotifier.colors.length)],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8), child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(children: [Text('Overview', style: Theme.of(context).textTheme.headline6), Spacer()]),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      movieListController.movieOverview,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          const SizedBox(width: 32),
        ],
      ),
    );
  }
}

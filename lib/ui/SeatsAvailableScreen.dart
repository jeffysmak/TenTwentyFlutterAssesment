import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ten_twenty/models/HallModel.dart';
import 'package:ten_twenty/notifiers/MovieListController.dart';
import 'package:ten_twenty/theme/ThemeNotifier.dart';
import 'package:ten_twenty/ui/BookSeatScreen.dart';
import 'package:ten_twenty/widgets/Buttons.dart';

class SeatsAvailableScreen extends StatelessWidget {
  static const Route = '/SeatsAvailableScreen';

  late AppThemeNotifier appThemeNotifier;
  late MovieListController movieListController;

  @override
  Widget build(BuildContext context) {
    appThemeNotifier = Provider.of<AppThemeNotifier>(context);
    movieListController = Provider.of<MovieListController>(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        centerTitle: true,
        title: ListTile(
          title: Text(
            movieListController.movieTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontWeight: FontWeight.normal,
                ),
          ),
          subtitle: Text(
            movieListController.generateInTheater(),
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  color: AppThemeNotifier.definedColor4,
                ),
            textAlign: TextAlign.center,
          ),
          contentPadding: const EdgeInsets.all(0),
          trailing: IconButton(icon: Icon(Icons.arrow_back, color: Colors.transparent), onPressed: () {}),
        ),
      ),
      body: Builder(
        builder: (_) {
          if (appThemeNotifier.isScreenWider) {
            return ViewWider();
          }
          return ViewPortrait();
        },
      ),
    );
  }
}

class ViewWider extends StatelessWidget {
  late MovieListController movieListController;

  @override
  Widget build(BuildContext context) {
    movieListController = Provider.of<MovieListController>(context);
    return Container(
      child: Center(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(children: [Text('Date', style: Theme.of(context).textTheme.headline6), Spacer()]),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: movieListController
                              .generateNextSevenDates()
                              .map(
                                (e) => Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Material(
                                          color: e == (movieListController.selected ?? movieListController.generateNextSevenDates().first)
                                              ? AppThemeNotifier.definedColor4
                                              : Theme.of(context).dividerColor,
                                          elevation: e == (movieListController.selected ?? movieListController.generateNextSevenDates().first) ? 4 : 0,
                                          shadowColor: AppThemeNotifier.definedColor4.withOpacity(0.75),
                                          borderRadius: BorderRadius.circular(AppThemeNotifier.inputBorderRadius),
                                          child: InkWell(
                                            onTap: () => movieListController.select(e),
                                            borderRadius: BorderRadius.circular(AppThemeNotifier.inputBorderRadius),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                                              child: Text(
                                                DateFormat('MMM d').format(e),
                                                style: Theme.of(context).textTheme.button!.copyWith(
                                                      color: e == (movieListController.selected ?? movieListController.generateNextSevenDates().first)
                                                          ? Theme.of(context).colorScheme.primary
                                                          : null,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            VerticalDivider(),
            const SizedBox(width: 12),
            Expanded(
              flex: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 16 / 15,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      children: movieListController.halls
                          .map(
                            (hall) => Container(
                              margin: const EdgeInsets.only(top: 8, right: 20, bottom: 8),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(DateFormat('hh:mm').format(hall.dateTime), style: Theme.of(context).textTheme.button),
                                      const SizedBox(width: 12),
                                      Text(hall.hallTitle, style: Theme.of(context).textTheme.bodyText2),
                                      Spacer(),
                                    ],
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(vertical: 10),
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(AppThemeNotifier.inputBorderRadius * 2),
                                        border: Border.all(color: AppThemeNotifier.definedColor4, width: 3),
                                      ),
                                      // child: Column(
                                      //   crossAxisAlignment: CrossAxisAlignment.center,
                                      //   mainAxisAlignment: MainAxisAlignment.center,
                                      //   children: [
                                      //     Image.asset('assets/screen.png'),
                                      //     Expanded(
                                      //       child: GridView.builder(
                                      //         physics: NeverScrollableScrollPhysics(),
                                      //         shrinkWrap: true,
                                      //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      //           crossAxisCount: 26,
                                      //           childAspectRatio: 1,
                                      //           crossAxisSpacing: 2,
                                      //           mainAxisSpacing: 2,
                                      //         ),
                                      //         itemBuilder: (_, index) {
                                      //           int seatValue = movieListController.seatPattern[index];
                                      //           return SvgPicture.asset('assets/seat.svg', color: movieListController.colorBySeatPatternAvailibility(seatValue));
                                      //         },
                                      //         itemCount: movieListController.seatPattern.length,
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                      child: Center(child: SvgPicture.asset('assets/hallll.svg', fit: BoxFit.cover)),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text('From', style: Theme.of(context).textTheme.bodyText2),
                                      const SizedBox(width: 8),
                                      Text(hall.from, style: Theme.of(context).textTheme.button),
                                      const SizedBox(width: 8),
                                      Text('Or', style: Theme.of(context).textTheme.bodyText2),
                                      const SizedBox(width: 8),
                                      Text('${hall.bonus} Bonus', style: Theme.of(context).textTheme.button),
                                      Spacer(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlineThemedButton(
                            onTap: () => Navigator.pushNamed(context, BookSeatsAvailableScreen.Route),
                            title: 'Select Seats',
                            color: AppThemeNotifier.definedColor4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
          ],
        ),
      ),
    );
  }
}

class ViewPortrait extends StatelessWidget {
  PageController pageController = PageController(initialPage: 0, viewportFraction: 0.88);
  late MovieListController movieListController;

  @override
  Widget build(BuildContext context) {
    movieListController = Provider.of<MovieListController>(context);
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(children: [Text('Date', style: Theme.of(context).textTheme.headline6), Spacer()]),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: movieListController
                              .generateNextSevenDates()
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Material(
                                    color: e == (movieListController.selected ?? movieListController.generateNextSevenDates().first)
                                        ? AppThemeNotifier.definedColor4
                                        : Theme.of(context).dividerColor,
                                    elevation: e == (movieListController.selected ?? movieListController.generateNextSevenDates().first) ? 4 : 0,
                                    shadowColor: AppThemeNotifier.definedColor4.withOpacity(0.75),
                                    borderRadius: BorderRadius.circular(AppThemeNotifier.inputBorderRadius),
                                    child: InkWell(
                                      onTap: () => movieListController.select(e),
                                      borderRadius: BorderRadius.circular(AppThemeNotifier.inputBorderRadius),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                                        child: Text(
                                          DateFormat('MMM d').format(e),
                                          style: Theme.of(context).textTheme.button!.copyWith(
                                                color: e == (movieListController.selected ?? movieListController.generateNextSevenDates().first)
                                                    ? Theme.of(context).colorScheme.primary
                                                    : null,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    AspectRatio(
                      aspectRatio: 16 / 10,
                      child: PageView.builder(
                        controller: pageController,
                        itemBuilder: (_, index) {
                          Hall hall = movieListController.halls[index];
                          return Container(
                            margin: const EdgeInsets.only(top: 8, right: 20, bottom: 8),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(DateFormat('hh:mm').format(hall.dateTime), style: Theme.of(context).textTheme.button),
                                    const SizedBox(width: 12),
                                    Text(hall.hallTitle, style: Theme.of(context).textTheme.bodyText2),
                                    Spacer(),
                                  ],
                                ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(vertical: 10),
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(AppThemeNotifier.inputBorderRadius * 2),
                                      border: Border.all(color: AppThemeNotifier.definedColor4, width: 3),
                                    ),
                                    // child: Column(
                                    //   crossAxisAlignment: CrossAxisAlignment.center,
                                    //   mainAxisAlignment: MainAxisAlignment.center,
                                    //   children: [
                                    //     Image.asset('assets/screen.png'),
                                    //     Expanded(
                                    //       child: GridView.builder(
                                    //         physics: NeverScrollableScrollPhysics(),
                                    //         shrinkWrap: true,
                                    //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    //           crossAxisCount: 26,
                                    //           childAspectRatio: 1,
                                    //           crossAxisSpacing: 2,
                                    //           mainAxisSpacing: 2,
                                    //         ),
                                    //         itemBuilder: (_, index) {
                                    //           int seatValue = movieListController.seatPattern[index];
                                    //           return SvgPicture.asset('assets/seat.svg', color: movieListController.colorBySeatPatternAvailibility(seatValue));
                                    //         },
                                    //         itemCount: movieListController.seatPattern.length,
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    child: Center(child: SvgPicture.asset('assets/hallll.svg', fit: BoxFit.cover)),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text('From', style: Theme.of(context).textTheme.bodyText2),
                                    const SizedBox(width: 8),
                                    Text(hall.from, style: Theme.of(context).textTheme.button),
                                    const SizedBox(width: 8),
                                    Text('Or', style: Theme.of(context).textTheme.bodyText2),
                                    const SizedBox(width: 8),
                                    Text('${hall.bonus} Bonus', style: Theme.of(context).textTheme.button),
                                    Spacer(),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: movieListController.halls.length,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlineThemedButton(
                    onTap: () => Navigator.pushNamed(context, BookSeatsAvailableScreen.Route),
                    title: 'Select Seats',
                    color: AppThemeNotifier.definedColor4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:ten_twenty/models/Pattrn.dart';
import 'package:ten_twenty/notifiers/MovieListController.dart';
import 'package:ten_twenty/theme/ThemeNotifier.dart';
import 'package:ten_twenty/ui/dashboard.dart';
import 'package:ten_twenty/widgets/Buttons.dart';

class BookSeatsAvailableScreen extends StatelessWidget {
  static const Route = '/BookSeatsAvailableScreen';
  late MovieListController movieListController;
  late AppThemeNotifier appThemeNotifier;

  @override
  Widget build(BuildContext context) {
    movieListController = Provider.of<MovieListController>(context);
    appThemeNotifier = Provider.of<AppThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
          splashRadius: 24,
        ),
        title: ListTile(
          title: Text(
            '${movieListController.movieTitle}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontWeight: FontWeight.normal,
                ),
          ),
          subtitle: Text(
            '${DateFormat('MMMM d, yyyy').format(DateTime.now())} | 12:30 Hall 1',
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
            return Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    color: Theme.of(context).colorScheme.primary,
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                                  child: Column(
                                    children: movieListController.getSeatAvailability
                                        .map(
                                          (e) => Row(
                                            children: e
                                                .map(
                                                  (ee) => Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset('assets/seat.svg', color: ee.color),
                                                          const SizedBox(width: 16),
                                                          Expanded(child: Text(ee.title)),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  height: 50,
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Material(
                                    color: AppThemeNotifier.materialBackground.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(AppThemeNotifier.inputBorderRadius),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(AppThemeNotifier.inputBorderRadius),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 12, right: 6),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('4 /', style: Theme.of(context).textTheme.button),
                                            Text('3 row', style: Theme.of(context).textTheme.bodyText1),
                                            const SizedBox(width: 8),
                                            IconButton(onPressed: () {}, icon: Icon(Icons.close)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: Theme.of(context).colorScheme.primary,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 32,
                                  child: Container(
                                    height: 50,
                                    child: Material(
                                      color: AppThemeNotifier.materialBackground.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(AppThemeNotifier.inputBorderRadius),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(AppThemeNotifier.inputBorderRadius),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 12, right: 6),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Total Price',
                                                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                                      fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,
                                                    ),
                                              ),
                                              Text('\$ 50', style: Theme.of(context).textTheme.button),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 68,
                                  child: OutlineThemedButton(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: Text('TASK FINISHED'),
                                          content: Text('😁 Its finished, now let see, awaiting for a response.'),
                                        ),
                                      );
                                    },
                                    title: 'Proceed to pay',
                                    color: AppThemeNotifier.definedColor4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 4,
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Stack(
                                  children: [
                                    Align(
                                      child: Image.asset('assets/screen.png'),
                                      alignment: Alignment.center,
                                    ),
                                    Align(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text('SCREEN',
                                            style: Theme.of(context).textTheme.caption!.copyWith(color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.5))),
                                      ),
                                      alignment: Alignment.center,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: GridView.count(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  crossAxisCount: 26,
                                  crossAxisSpacing: 2,
                                  mainAxisSpacing: 2,
                                  children: movieListController.seatPattern
                                      .map((e) => SvgPicture.asset('assets/seat.svg', color: movieListController.colorBySeatPatternAvailibility(e)))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 65,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          child: InteractiveViewer(
                            minScale: 0.5,
                            maxScale: 4,
                            child: Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Stack(
                                        children: [
                                          Align(
                                            child: Image.asset('assets/screen.png'),
                                            alignment: Alignment.center,
                                          ),
                                          Align(
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Text('SCREEN',
                                                  style: Theme.of(context).textTheme.caption!.copyWith(color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.5))),
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: GridView.count(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        crossAxisCount: 26,
                                        crossAxisSpacing: 2,
                                        mainAxisSpacing: 2,
                                        children: movieListController.seatPattern
                                            .map((e) => SvgPicture.asset('assets/seat.svg', color: movieListController.colorBySeatPatternAvailibility(e)))
                                            .toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: Row(
                        children: [
                          Material(
                            color: Theme.of(context).primaryColor,
                            elevation: 1,
                            borderRadius: BorderRadius.circular(56),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(56),
                              onTap: () {},
                              child: Padding(padding: const EdgeInsets.all(5.0), child: Icon(Icons.add)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Material(
                            color: Theme.of(context).primaryColor,
                            elevation: 1,
                            borderRadius: BorderRadius.circular(56),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(56),
                              onTap: () {},
                              child: Padding(padding: const EdgeInsets.all(5.0), child: Icon(Icons.remove)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 35,
                child: Container(
                  color: Theme.of(context).colorScheme.primary,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                          child: Column(
                            children: movieListController.getSeatAvailability
                                .map(
                                  (e) => Row(
                                    children: e
                                        .map(
                                          (ee) => Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset('assets/seat.svg', color: ee.color),
                                                  const SizedBox(width: 16),
                                                  Expanded(child: Text(ee.title)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: Material(
                            color: AppThemeNotifier.materialBackground.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppThemeNotifier.inputBorderRadius),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(AppThemeNotifier.inputBorderRadius),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12, right: 6),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('4 /', style: Theme.of(context).textTheme.button),
                                    Text('3 row', style: Theme.of(context).textTheme.bodyText1),
                                    const SizedBox(width: 8),
                                    IconButton(onPressed: () {}, icon: Icon(Icons.close)),
                                  ],
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
              Container(
                color: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 32,
                        child: Container(
                          height: 50,
                          child: Material(
                            color: AppThemeNotifier.materialBackground.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppThemeNotifier.inputBorderRadius),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(AppThemeNotifier.inputBorderRadius),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12, right: 6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Total Price',
                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                            fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,
                                          ),
                                    ),
                                    Text('\$ 50', style: Theme.of(context).textTheme.button),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 68,
                        child: OutlineThemedButton(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text('TASK FINISHED'),
                                content: Text('😁 Its finished, now let see, awaiting for a response.'),
                              ),
                            );
                          },
                          title: 'Proceed to pay',
                          color: AppThemeNotifier.definedColor4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

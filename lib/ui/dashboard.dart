import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ten_twenty/notifiers/HomeScreenController.dart';
import 'package:ten_twenty/notifiers/MovieListController.dart';
import 'package:ten_twenty/theme/ThemeNotifier.dart';

class DashboardScreen extends StatefulWidget {
  static const Route = '/Dashboard';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late HomeScreenController homeScreenController;
  late MovieListController movieListController;

  @override
  Widget build(BuildContext context) {
    homeScreenController = Provider.of<HomeScreenController>(context);
    movieListController = Provider.of<MovieListController>(context);
    movieListController.initializeMovieGenres();
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 75,
          title: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 6),
            child: Row(
              children: [
                if (!homeScreenController.searchScreen) ...[
                  Text(
                    homeScreenController.screenTitles[homeScreenController.currentScreenIndex],
                  ),
                  Spacer(),
                  IconButton(onPressed: () => homeScreenController.search(), icon: Icon(Icons.search), splashRadius: 20)
                ] else if (homeScreenController.submitted && homeScreenController.searchController.text.isNotEmpty) ...[
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: () => homeScreenController.clearSubmittedSearch(), icon: Icon(Icons.arrow_back_ios), splashRadius: 24),
                        Text(
                          '${homeScreenController.searchedResults(context).length} ${homeScreenController.searchedResults(context).length > 1 ? 'Results Found' : 'Result Found'}',
                          style: Theme.of(context).textTheme.button!.copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: TextField(
                      controller: homeScreenController.searchController,
                      onChanged: homeScreenController.onSearch,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (v) => homeScreenController.setSearched(),
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(AppThemeNotifier.inputBorderRadius * 3), borderSide: BorderSide(color: Colors.transparent)),
                        enabledBorder:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(AppThemeNotifier.inputBorderRadius * 3), borderSide: BorderSide(color: Colors.transparent)),
                        focusedBorder:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(AppThemeNotifier.inputBorderRadius * 3), borderSide: BorderSide(color: Colors.transparent)),
                        prefixIcon: Icon(Icons.search, size: 26, color: AppThemeNotifier.definedColor1),
                        prefixIconConstraints: BoxConstraints(maxWidth: 50, minWidth: 50, minHeight: 50, maxHeight: 50),
                        hintText: 'TV Shows, movies and more',
                        suffixIcon: InkWell(
                          child: Icon(Icons.close, size: 26, color: AppThemeNotifier.definedColor1.withOpacity(0.75)),
                          onTap: () => homeScreenController.clearSearch(context),
                          borderRadius: BorderRadius.circular(AppThemeNotifier.inputBorderRadius * 3),
                        ),
                        suffixIconConstraints: BoxConstraints(maxWidth: 50, minWidth: 50, minHeight: 50, maxHeight: 50),
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
        body: homeScreenController.currentScreen,
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
          child: BottomNavigationBar(
            currentIndex: homeScreenController.currentScreenIndex,
            backgroundColor: AppThemeNotifier.definedColor1,
            onTap: (int i) => homeScreenController.changeScreenIndex(i),
            items: [
              BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/dashboard.svg',
                      color: homeScreenController.currentScreenIndex == 0 ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(0.54)),
                  label: homeScreenController.screenTitles[0]),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/media.svg',
                      color: homeScreenController.currentScreenIndex == 1 ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(0.54)),
                  label: homeScreenController.screenTitles[1]),
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/library.svg',
                    color: homeScreenController.currentScreenIndex == 2 ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(0.54)),
                label: homeScreenController.screenTitles[2],
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/list.svg',
                    color: homeScreenController.currentScreenIndex == 3 ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(0.54)),
                label: homeScreenController.screenTitles[3],
              ),
            ],
          ),
        ),
      ),
      onWillPop: onWillPop,
    );
  }

  Future<bool> onWillPop() async {
    if (homeScreenController.submitted) {
      homeScreenController.submitted = false;
      homeScreenController.notifyListeners();
      return false;
    }
    if (homeScreenController.searchScreen) {
      homeScreenController.searchScreen = false;
      homeScreenController.notifyListeners();
      return false;
    }
    print('Now Here');
    return true;
  }
}

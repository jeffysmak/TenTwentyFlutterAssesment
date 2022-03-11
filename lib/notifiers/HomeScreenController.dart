import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ten_twenty/models/UpcomingMovieResponse.dart';
import 'package:ten_twenty/notifiers/MovieListController.dart';
import 'package:ten_twenty/ui/dashboard/dashboard.dart';
import 'package:ten_twenty/ui/dashboard/library.dart';
import 'package:ten_twenty/ui/dashboard/more.dart';
import 'package:ten_twenty/ui/dashboard/watch.dart';

class HomeScreenController extends ChangeNotifier {
  int currentScreenIndex = 0;
  bool searchScreen = false;
  bool submitted = false;
  TextEditingController searchController = TextEditingController();

  List<String> screenTitles = [
    'Dashboard',
    'Watch',
    'Library',
    'More',
  ];

  void search() {
    searchController.clear();
    this.searchScreen = !searchScreen;
    notifyListeners();
  }

  void onSearch(String? v) {
    notifyListeners();
  }

  void clearSearch(BuildContext context) {
    searchController.clear();
    submitted = false;
    FocusScope.of(context).requestFocus(new FocusNode());
    notifyListeners();
  }

  void changeScreenIndex(int i) {
    this.currentScreenIndex = i;
    searchScreen = false;
    submitted = false;
    searchController.clear();
    notifyListeners();
  }

  Widget get currentScreen {
    if (searchScreen) {
      return SearchScreen();
    }
    searchController.clear();
    switch (currentScreenIndex) {
      case 0:
        return ScreenDashboard();
      case 1:
        return ScreenWatch();
      case 2:
        return ScreenLibrary();
      case 3:
        return ScreenMore();
      default:
        return ScreenDashboard();
    }
  }

  void setSearched() {
    this.submitted = true;
    notifyListeners();
  }

  void clearSubmittedSearch() {
    this.submitted = false;
    searchController.clear();
    this.searchScreen = false;
    notifyListeners();
  }

  List<Results> searchedResults(BuildContext context) {
    if (searchController.text.isEmpty) {
      return <Results>[];
    }
    UpcomingMovieResponse? movieResponse = Provider.of<MovieListController>(context, listen: false).upcomingMovieResponse;
    if (movieResponse == null) return <Results>[];
    return movieResponse.results!.where((Results movie) {
      return movie.title!.toLowerCase().startsWith(searchController.text.toLowerCase());
    }).toList();
  }
}

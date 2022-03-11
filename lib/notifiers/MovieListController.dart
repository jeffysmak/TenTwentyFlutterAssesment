import 'dart:math';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ten_twenty/NetworkConnectivityHelper.dart';
import 'package:ten_twenty/models/Genre.dart';
import 'package:ten_twenty/models/HallModel.dart';
import 'package:ten_twenty/models/Seat.dart';
import 'package:ten_twenty/models/UpcomingMovieResponse.dart';
import 'package:ten_twenty/models/VimeoVideo.dart';
import 'package:collection/collection.dart';

class MovieListController extends ChangeNotifier {
  final String _ENDPOINT = "https://api.themoviedb.org/3";
  final String _API_KEY = "b3c2d780857c6958e24153bd8a078a74";

  List<Genre>? movieGenres;
  UpcomingMovieResponse? upcomingMovieResponse;

  Future<void> initializeMovies() async {
    if (upcomingMovieResponse != null && upcomingMovieResponse!.results!.isNotEmpty) return;
    if (!(await NetworkConnectivityHelper().checkConnectivity())) {
      BotToast.showText(text: 'No internet connection');
      upcomingMovieResponse = UpcomingMovieResponse();
      notifyListeners();
      return;
    }
    Dio dio = Dio();
    try {
      Response response = await dio.request('$_upcomingMoviesEndpoint');
      if (response.statusCode == 200) {
        print('\n\nResponse -> ${response.data}');
        this.upcomingMovieResponse = UpcomingMovieResponse.fromMap(response.data);
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}\n');
      } else {
        print('Error sending request!');
        print(e.message);
      }
      upcomingMovieResponse = UpcomingMovieResponse();
      BotToast.showText(text: e.message);
    }
    notifyListeners();
  }

  Future<void> initializeMovieGenres() async {
    if (movieGenres != null && movieGenres!.isNotEmpty) return;
    Dio dio = Dio();
    try {
      Response response = await dio.request(_movieGenresEndpoint);
      if (response.statusCode == 200) {
        print('\n\nResponse -> ${response.data}');
        this.movieGenres = List.from(response.data['genres']).map((e) => Genre.fromMap(e)).toList();
        print('Length -> ${movieGenres!.length} ${movieGenres!.first.title}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}\n');
      } else {
        print('Error sending request!');
        print(e.message);
      }
    }
    initializeMovies();
    notifyListeners();
  }

  String get _movieGenresEndpoint => "$_ENDPOINT/genre/movie/list?api_key=$_API_KEY";

  String get _upcomingMoviesEndpoint => "$_ENDPOINT/movie/upcoming?api_key=$_API_KEY";

  String get _vimeoVideoEndpoint => "$_ENDPOINT/movie/<VIDID>/videos?api_key=$_API_KEY";

  String generateMoviePoster(String? path) {
    if (path != null) {
      return 'https://image.tmdb.org/t/p/w500$path';
    }
    return 'https://cdn.mos.cms.futurecdn.net/fM7oKQDCKpgMuobZpFwRgK.jpg';
  }

  String generateRandomPoster() {
    return upcomingMovieResponse != null && upcomingMovieResponse!.results != null
        ? generateMoviePoster(upcomingMovieResponse!.results![new Random().nextInt(upcomingMovieResponse!.results!.length)].posterPath)
        : 'https://cdn.mos.cms.futurecdn.net/fM7oKQDCKpgMuobZpFwRgK.jpg';
  }

  void getVimeoVideo(Results movie) async {
    Dio dio = Dio();
    try {
      Response response = await dio.get(_vimeoVideoEndpoint.replaceAll('<VIDID>', '${movie.id!}'));
      if (response.statusCode == 200) {
        print('\n\nResponse -> ${response.data}');
        if (response.data['results'] != null) {
          List<VimeoVideo> videosList = List.from(response.data['results']).map((e) => VimeoVideo.fromJson(e)).toList();
          if (videosList.isNotEmpty) {
            VimeoVideo? video = videosList.firstWhereOrNull((element) => element.site!.toLowerCase() == 'vimeo');
            this.selectedMovieVideo = video;
          } else {
            this.selectedMovieVideo = null;
          }
        }
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}\n');
      } else {
        print('Error sending request!');
        print(e.message);
      }
      this.selectedMovieVideo = null;
    }
    busy = false;
    notifyListeners();
  }

  /// For Movie Detailed
  Results? selectedMovieDetailed;
  bool busy = false;
  VimeoVideo? selectedMovieVideo;

  void setSelected(Results? selected) {
    this.selectedMovieDetailed = selected;
    selectedMovieVideo = null;
    busy = true;
    if (selected != null) {
      getVimeoVideo(selectedMovieDetailed!);
    }
    notifyListeners();
  }

  String get movieTitle => selectedMovieDetailed != null ? '${selectedMovieDetailed!.title}' : 'Free Run';

  String get movieOverview => selectedMovieDetailed != null
      ? '${selectedMovieDetailed!.overview}'
      : 'As a collection of history\'s worst tyrants and criminal masterminds gather to plot a war to wipe out millions, one man must race against time to stop them. Discover the origins of the very first independent intelligence agency in The King\'s Man. The Comic Book “The Secret Service” by Mark Millar and Dave Gibbons.';

  String genreById(int id) {
    if (this.movieGenres != null && this.movieGenres!.isNotEmpty) {
      Genre? genre = movieGenres!.firstWhere((element) => element.id == id);
      if (genre != null) {
        return genre.title;
      }
    }
    return 'Action (Static)';
  }

  String generateInTheater() {
    if (selectedMovieDetailed != null) {
      DateTime? dateTime = DateTime.tryParse(selectedMovieDetailed!.releaseDate!);
      if (dateTime != null) {
        return 'In Theaters ${DateFormat('MMMM dd, yyyy').format(dateTime)}';
      }
      return 'In Theaters December 22, 2021';
    }
    return 'In Theaters December 22, 2021';
  }

  List<DateTime> generateNextSevenDates() => List.generate(7, (index) => DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + index));
  DateTime? selected;

  void select(DateTime time) => {this.selected = time, notifyListeners()};

  List<Hall> halls = [
    Hall(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, 30), 'Cinetech + Hall 1', '50\$', '2500'),
    Hall(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour + 1, 30), 'Cinetech + Hall 2', '75\$', '3000'),
    Hall(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour + 2, 30), 'Cinetech + Hall 3', '100\$', '3500'),
    Hall(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour + 3, 30), 'Cinetech + Hall 4', '125\$', '4000'),
  ];

  Hall? selectedHall;

  void selectHall(Hall hal) => {this.selectedHall = hal, notifyListeners()};

  List<List<Seat>> getSeatAvailability = [
    [Seat(Color(0x0ffCD9D0F), 'Selected'), Seat(Color(0x0ffA6A6A6), 'Not Available')],
    [Seat(Color(0x0ff564CA3), 'VIP (150\$)'), Seat(Color(0x0ff61C3F2), 'Regular')],
  ];

  List<int> seatPattern = [
    0,
    0,
    0,
    1,
    1,
    0,
    1,
    1,
    2,
    2,
    1,
    1,
    2,
    2,
    1,
    1,
    2,
    2,
    1,
    1,
    0,
    2,
    2,
    0,
    0,
    0,
    0,
    2,
    1,
    2,
    1,
    0,
    2,
    2,
    1,
    1,
    2,
    2,
    1,
    1,
    2,
    2,
    1,
    1,
    2,
    2,
    0,
    2,
    1,
    2,
    1,
    0,
    0,
    1,
    2,
    1,
    1,
    0,
    3,
    3,
    1,
    1,
    2,
    2,
    1,
    1,
    2,
    2,
    1,
    1,
    3,
    3,
    0,
    1,
    1,
    2,
    1,
    0,
    0,
    1,
    1,
    2,
    1,
    0,
    1,
    1,
    2,
    2,
    1,
    1,
    2,
    2,
    1,
    1,
    2,
    2,
    1,
    1,
    0,
    1,
    2,
    1,
    1,
    0,
    2,
    2,
    1,
    1,
    1,
    0,
    4,
    4,
    1,
    1,
    2,
    2,
    1,
    1,
    2,
    2,
    1,
    1,
    4,
    4,
    0,
    1,
    1,
    1,
    2,
    2,
    1,
    1,
    2,
    2,
    1,
    0,
    1,
    1,
    2,
    2,
    1,
    1,
    5,
    5,
    1,
    1,
    2,
    2,
    1,
    1,
    0,
    1,
    2,
    2,
    1,
    1,
    2,
    1,
    2,
    1,
    2,
    0,
    2,
    2,
    1,
    1,
    2,
    2,
    1,
    1,
    2,
    2,
    1,
    1,
    2,
    2,
    0,
    2,
    1,
    2,
    1,
    2,
    2,
    1,
    2,
    1,
    2,
    0,
    2,
    2,
    1,
    1,
    2,
    2,
    1,
    1,
    2,
    2,
    1,
    1,
    2,
    2,
    0,
    2,
    1,
    2,
    1,
    2,
    2,
    1,
    2,
    1,
    2,
    0,
    2,
    2,
    1,
    1,
    2,
    2,
    1,
    1,
    2,
    2,
    1,
    1,
    2,
    2,
    0,
    2,
    1,
    2,
    1,
    2,
    2,
    1,
    2,
    1,
    2,
    0,
    2,
    2,
    1,
    1,
    2,
    2,
    1,
    1,
    2,
    2,
    1,
    1,
    2,
    2,
    0,
    2,
    1,
    2,
    1,
    2,
    2,
    1,
    2,
    1,
    2,
    0,
    2,
    2,
    1,
    1,
    2,
    2,
    1,
    1,
    2,
    2,
    1,
    1,
    2,
    2,
    0,
    2,
    1,
    2,
    1,
    2,
    2,
    1,
    2,
    1,
    2,
    0,
    2,
    2,
    1,
    1,
    2,
    2,
    1,
    1,
    2,
    2,
    1,
    1,
    2,
    2,
    0,
    2,
    1,
    2,
    1,
    2,
    2,
    1,
    2,
    1,
    2,
    0,
    2,
    2,
    1,
    1,
    2,
    2,
    1,
    1,
    2,
    2,
    1,
    1,
    2,
    2,
    0,
    2,
    1,
    2,
    1,
    2,
    2,
    1,
    2,
    1,
    2,
    0,
    2,
    2,
    1,
    1,
    2,
    2,
    1,
    1,
    2,
    5,
    1,
    1,
    2,
    2,
    0,
    2,
    4,
    2,
    1,
    2,
    0,
    1,
    2,
    4,
    0,
    0,
    0,
    2,
    1,
    1,
    3,
    0,
    0,
    0,
    0,
    2,
    1,
    5,
    2,
    0,
    0,
    0,
    1,
    2,
    1,
    0,
  ];

  Color colorBySeatPatternAvailibility(int pattern) {
    switch (pattern) {
      case 0:
        return Colors.transparent;
      case 1:
        return Color(0x0ffA6A6A6).withOpacity(0.5);
      case 2:
        return Color(0x0ff61C3F2);
      case 3:
        return Color(0x0ff15D2BC);
      case 4:
        return Color(0x0ffE26CA5);
      case 5:
        return Color(0x0ff564CA3);
      default:
        return Colors.transparent;
    }
  }
}

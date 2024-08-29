import 'package:movie_recommendation/api_services/api_service.dart';
import 'package:movie_recommendation/common_utilites/common_functions.dart';

class Api
{
  static const String baseURL = "https://movie-recommendation-8tym.onrender.com/";
  static const String movieDBURL = "https://api.themoviedb.org/3/movie/";
  static const String movieDBCollectionURL = "https://api.themoviedb.org/3/collection/";
  static const String baseLocalURL = "http://192.168.0.101:5000/";
  static const String getMovies = "fetch-movies";
  static const String getMoviesSuggestions = "fetch-suggestions";
  static const String getMoviesDetails = "fetch-movies-details";
  static const String trendingMovies = "https://api.themoviedb.org/3/trending/movie/";
  static const String searchMovies = "https://api.themoviedb.org/3/search/movie";
  static const String youtubeThumbnailBaseUrl = "https://img.youtube.com/vi/";
  static const String youtubeVideoPlayUrl = "https://www.youtube.com/watch?v=";
  static const String fetchPersonInfo = "https://api.themoviedb.org/3/person/";
  static const String tmdbImageBaseUrl = "https://image.tmdb.org/t/p/w500/";
  static const String omdbBaseUrl = "http://www.omdbapi.com/";

  /// Fetch Movies
  static Future<dynamic> fetchMovies({required Map<String, String> param}) async {
    return await ApiService().get(getMovies, params:param);
  }

  /// Fetch Suggestions
  static Future<dynamic> fetchMoviesSuggestions({required Map<String, String> param}) async {
    return await ApiService().get(getMoviesSuggestions,  params:param);
  }

  /// Fetch movie details
  static Future<dynamic> fetchMoviesDetails({required int id}) async {
    return await ApiServiceTMDB().get("${id}");
  }

  /// Fetch movie credits
  static Future<dynamic> fetchMovieCredits({required int id}) async {
    return await ApiServiceTMDB().get("${id}/credits");
  }

  /// Fetch movie credits
  static Future<dynamic> fetchMovieCollection({required int id}) async {
    return await ApiServiceTMDB().get(baseUrl: movieDBCollectionURL, "$id");
  }

  static Future<dynamic> fetchNowPlayingMovies() async {
    return await ApiServiceTMDB().get("now_playing");
  }

  static Future<dynamic> fetchUpcomingMovies() async {
    return await ApiServiceTMDB().get("upcoming");
  }

  static Future<dynamic> fetchTrendingMovies({String timeWindow = "day"}) async {
    return await ApiServiceTMDB().get(baseUrl: trendingMovies, timeWindow);
  }

  static Future<dynamic> fetchSearchedMovies({required Map<String, String> param}) async {
    return await ApiServiceTMDB().get(baseUrl: searchMovies, "", params: param );
  }

  static Future<dynamic> fetchVideosOfMovies({required movieId}) async {
    return await ApiServiceTMDB().get(baseUrl: movieDBURL, "$movieId/videos");
  }

  static Future<dynamic> fetchPersonDetails({required String id}) async {
    return await ApiServiceTMDB().get(CommonFunctions().getPersonInfo(id));
  }

  static Future<dynamic> fetchIMDBDetails({required Map<String, String> params}) async {
    CommonFunctions.printLog("-----> Fetchin IM");
    return await ApiService().get("", baseUrl: omdbBaseUrl, params: params, );
  }

}
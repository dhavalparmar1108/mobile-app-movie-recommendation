import 'package:movie_recommendation/api_services/api_service.dart';

class Api
{
  static const String baseURL = "https://movie-recommendation-8tym.onrender.com/";
  static const String movieDBURL = "https://api.themoviedb.org/3/movie/";
  static const String movieDBCollectionURL = "https://api.themoviedb.org/3/";
  static const String baseLocalURL = "http://192.168.0.101:5000/";
  static const String getMovies = "fetch-movies";
  static const String getMoviesSuggestions = "fetch-suggestions";
  static const String getMoviesDetails = "fetch-movies-details";

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
    return await ApiServiceTMDB().get("${movieDBURL}/${id}");
  }

  /// Fetch movie credits
  static Future<dynamic> fetchMovieCredits({required int id}) async {
    return await ApiServiceTMDB().get("${movieDBURL}${id}/credits");
  }

  /// Fetch movie credits
  static Future<dynamic> fetchMovieCollection({required int id}) async {
    return await ApiServiceTMDB().get("${movieDBCollectionURL}/collection/$id");
  }
}
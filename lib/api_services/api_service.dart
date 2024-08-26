import 'package:dio/dio.dart';
import 'package:movie_recommendation/api_services/api.dart';
import 'package:movie_recommendation/api_services/interceptor.dart';
import 'package:movie_recommendation/constants/constants.dart';

import '../common_utilites/common_functions.dart';

class ApiService
{
  var _options = BaseOptions(
    baseUrl: Api.baseLocalURL,
    connectTimeout: Duration(seconds: 8),
    receiveTimeout: Duration(seconds: 10),
  );

  late Dio _dio = Dio();

  ApiService()
  {
    _dio.options = _options;
    _dio.interceptors.add(CustomInterceptors());
  }

  Future<Response> get(String route , {Map<String, dynamic>? params, String? baseUrl})
  async {
    Response response;
    if(baseUrl != null)
      {
        _dio.options.baseUrl = baseUrl;
      }
    if(params != null)
      {
         response = await _dio.get(route, queryParameters: params);
      }
    else
      {
          response = await _dio.get(route);
      }
    CommonFunctions.printLog(response.toString());
    return response;
  }
}

class ApiServiceTMDB
{
  final _options = BaseOptions(
    baseUrl: Api.movieDBURL,
    connectTimeout: Duration(seconds: 8),
    receiveTimeout: Duration(seconds: 10),
  );

  late Dio _dio = Dio();

  ApiServiceTMDB()
  {
    _dio.options = _options;
    _dio.options.headers['Authorization'] = 'Bearer ${Constants.token}';
    _dio.interceptors.add(CustomInterceptors());
  }

  Future<Response> get(String route , {Map<String, dynamic>? params, String? baseUrl})
  async {
    Response response;
    if(params != null)
    {
      response = await _dio.get(route, queryParameters: params);
    }
    else
    {
      response = await _dio.get(route);
    }
    CommonFunctions.printLog(response.toString());
    return response;
  }
}
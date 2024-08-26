
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:movie_recommendation/common_utilites/common_functions.dart';

class CustomInterceptors extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    CommonFunctions.printLog('REQUEST[${options.method}] => PATH: ${options.uri} param ${options.data}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    CommonFunctions.printLog('RESPONSE[${response.statusMessage}] => PATH: ${response.requestOptions.path}');
    CommonFunctions.printLog("- ${jsonEncode(response.data)}");
    return super.onResponse(response, handler);
  }

  @override
   onError(DioException err, ErrorInterceptorHandler handler) async{
    CommonFunctions.printLog('ERROR[${err.message.toString()}] => PATH: ${err.requestOptions.path} ${err.type} -- ${err.response.toString()} -- ${err.type}');
    try
    {
        if(err.type == DioExceptionType.connectionTimeout || err.type == DioExceptionType.receiveTimeout)
        {
          Response response = Response(requestOptions: err.requestOptions, statusCode: 504, statusMessage: "Gateway Timeout!");
          return handler.resolve(response);
        }
        else if(err.type == DioExceptionType.badResponse){
          Response response = Response(requestOptions: err.requestOptions, statusCode: 500, statusMessage: "We don't have this movie!");
          return handler.resolve(response);
        }
        else
          {
            Response response = Response(requestOptions: err.requestOptions, statusCode: 500, statusMessage: "Something went wrong!");
            return handler.resolve(response);
          }
    }
    catch(e)
    {
        CommonFunctions.printLog("");
    }
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_recommendation/api_services/api.dart';
import 'package:movie_recommendation/common_utilites/common_functions.dart';
import 'package:movie_recommendation/common_utilites/common_widgets.dart';
import 'package:movie_recommendation/models/movies_list.dart' hide Recommendations;
import 'package:movie_recommendation/recommendations.dart';
import 'package:movie_recommendation/screen_util/screen_util.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String name = "";
  MoviesList moviesList = MoviesList();
  bool isLoading = false;
  TextEditingController textEditingController = TextEditingController();

  // Add DropDownSearch 
  Future<bool> fetchMovie()
  async{
    try
    {
      if(FocusScope.of(context).hasFocus)
        {
          FocusScope.of(context).unfocus();
        }
      setState(() {
        isLoading = true;
      });
        Map<String,String> param = {
          'name' : name
        };
        Response response = await Api.fetchMovies(param: param);
        CommonFunctions.printLog(response.toString());
         if(response.statusCode == 200)
         {
           moviesList = MoviesList.fromJson(response.data);
           setState(() {});
            if(mounted)
              {
                setState(() {
                  isLoading = false;
                });
                await Navigator.push(context, MaterialPageRoute(builder: (context) => Recommendations(moviesList: moviesList, movie:  name,)));
                setState(() {
                  moviesList = MoviesList();
                });
              }
         }
         else
         {
           setState(() {
             isLoading = false;
           });
           throw Exception(response.statusMessage);
         }
         return true;
    }
    catch(e)
    {
        String message = e.toString().replaceFirst('Exception: ', '');
        CommonFunctions().showToast(message);
        return false;
    }
  }

  Future<bool> fetchSuggestions()
  async{
    try
    {
      Map<String,String> param = {
        'name' : name
      };
      Response response = await Api.fetchMoviesSuggestions(param: param);
      CommonFunctions.printLog(response.toString());
      if(response.statusCode == 200)
      {


      }
      else
      {

      }
      return true;
    }
    catch(e)
    {
      String message = e.toString().replaceFirst('Exception: ', '');
      CommonFunctions().showToast(message);
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SizeConstants.setScreenAwareConstant(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(height: 30.h,),
                  Text("Discover Your Next Favorite Film,\nOne Recommendation at a Time.", style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold
                  ),),
                  SizedBox(height: 30.h,),
                  /// Try Kalki (Error)
                  TextField(
                    controller: textEditingController,
                    decoration: const InputDecoration(
                      hintText: "Movie"
                    ),
                    onChanged: (val){
                      setState(() {
                        name = val;
                      });
                      //fetchSuggestions();
                    },
                  ),
                  SizedBox(height: 30.h,),
                  ElevatedButton(onPressed: () async {
                    setState(() {});
                    await fetchMovie();}, child: const Text("Recommend" ,style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),),),
                ],
              ),
            ),
            isLoading ?  CommonWidgets().Loader() : Container()
          ],
        ) ,
      ),
    );
  }
}

import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_recommendation/api_services/api.dart';
import 'package:movie_recommendation/common_utilites/common_functions.dart';
import 'package:movie_recommendation/common_utilites/common_widgets.dart';
import 'package:movie_recommendation/common_utilites/custom_navigation.dart';
import 'package:movie_recommendation/constants/constants.dart';
import 'package:movie_recommendation/models/movies_list.dart' hide Recommendations;
import 'package:movie_recommendation/movie_screens/movie_home_page.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      key: _scaffoldKey,
      // drawer: Drawer(
      //   child: Column(
      //     children: [
      //       SizedBox(height: 50.h,),
      //       Image.asset(AssetConstants.appLogo, height: 70.h,),
      //       SizedBox(height: 50.h,),
      //       Divider(height: 8,),
      //       InkWell(
      //         onTap: (){
      //           CustomNavigation.push(context, MovieHomePage());
      //         },
      //         child: Card(
      //           child: Padding(
      //             padding: const EdgeInsets.all(8.0),
      //             child: Row(
      //               children: [
      //                 Icon(Icons.movie_creation),
      //                 SizedBox(width: 10.w,),
      //                 Text("Movie")
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //       Card(
      //         child: Padding(
      //           padding: const EdgeInsets.all(8.0),
      //           child: Row(
      //             children: [
      //               Icon(Icons.movie_filter),
      //               SizedBox(width: 10.w,),
      //               Text("TV Shows")
      //             ],
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              right: 10.w,
              top: 10.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: (){
                      CustomNavigation.push(context, const MovieHomePage());
                    },
                    child: Material(
                      elevation: 10,
                      shadowColor: Colors.blueGrey,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.indigoAccent,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text("Movies", style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold
                                ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5.w,),
                  Material(
                    elevation: 10,
                    shadowColor: Colors.blueGrey,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.indigoAccent,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text("TV Series", style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold
                              ),)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Positioned(
            //     left: 10.w,
            //     top: 10.h,
            //     child: CircleAvatar(
            //       child: InkWell(
            //         onTap: (){
            //             _scaffoldKey.currentState?.openDrawer();
            //           },
            //         child: Icon(Icons.density_medium_rounded),
            //       ),
            //     )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(height: 50.h,),
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

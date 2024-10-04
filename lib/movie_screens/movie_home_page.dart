import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_recommendation/common_utilites/common_functions.dart';
import 'package:movie_recommendation/common_utilites/custom_navigation.dart';
import 'package:movie_recommendation/models/movie_results_model.dart';
import 'package:movie_recommendation/models/now_playing_movies_model.dart';
import 'package:movie_recommendation/models/trending_movies_model.dart';
import 'package:movie_recommendation/models/upcoming_movies_model.dart';
import 'package:movie_recommendation/movie_details_screen.dart';
import 'package:movie_recommendation/movie_screens/movie_info_page.dart';
import 'package:movie_recommendation/screen_util/screen_util.dart';

import '../api_services/api.dart';
class MovieHomePage extends StatefulWidget {
  const MovieHomePage({super.key});

  @override
  State<MovieHomePage> createState() => _MovieHomePageState();
}

class _MovieHomePageState extends State<MovieHomePage> {

  NowPlayingMoviesModel? nowPlayingMoviesModel;
  UpcomingMoviesModel? upcomingMoviesModel;
  TrendingMoviesModel? trendingMoviesModel;
  TextEditingController textEditingController = TextEditingController();
  String searchMovie = "";

  Widget NowPlaying()
  {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          nowPlayingMoviesModel == null ? Container() : Padding(
              padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 4.h),
              child: Row(
                children: [
                  Text("Now Playing", style: GoogleFonts.raleway(fontSize: 20.sp, fontWeight: FontWeight.bold,),),
                  Spacer(),
                  InkWell(
                      onTap: (){
                        List<MovieResultsModel> movies = nowPlayingMoviesModel!.results!.map((e) {
                          return MovieResultsModel.fromJson(e.toJson());
                        }).toList();
                        CustomNavigation.push(context, SeeAll(movieResultsModel: movies,));
                      },
                      child: Text("See all >>", style: GoogleFonts.lato(fontSize: 15.sp, color: Colors.grey),))
                ],
              )
          ),

          /// Now Playing Movies Listview
          nowPlayingMoviesModel == null ? Container() : Container(
            height: 300.h, // Height of the horizontal ListView
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, idx){
                return Padding(
                  padding: const EdgeInsets.all(3),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: (){
                        CustomNavigation.push(context, MovieDetails(id: nowPlayingMoviesModel!.results!.elementAt(idx).id!));
                      },
                      child: Container(
                        width: 150.w,
                        child: Stack(
                          children: [
                            Image.network(CommonFunctions().getTMDBImage(posterPath: nowPlayingMoviesModel!.results!.elementAt(idx).posterPath!),
                                height: 300.h,
                                width: 150.w,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stack){
                                  return Container();
                                }
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 150.h,
                                width: 150.w,// Adjust this height as needed
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.7), // Fading effect
                                    ],
                                    stops: const [0.5, 1.0], // Gradient stop points
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(3,0,3,0),
                              child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child:Text(nowPlayingMoviesModel!.results!.elementAt(idx).originalTitle!,
                                    style: GoogleFonts.openSans(
                                        fontSize:16.sp
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget UpComing()
  {
    return  Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          upcomingMoviesModel == null ? Container() : Padding(
            padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 4.h),
            child: Row(
              children: [
                Text("Upcoming", style: GoogleFonts.raleway(fontSize: 20.sp, fontWeight: FontWeight.bold,),),
                Spacer(),
                InkWell(
                    onTap: (){
                      List<MovieResultsModel> movies = upcomingMoviesModel!.results!.map((e) {
                        return MovieResultsModel.fromJson(e.toJson());
                      }).toList();
                      CustomNavigation.push(context, SeeAll(movieResultsModel: movies,));
                    },
                    child: Text("See all >>", style: GoogleFonts.lato(fontSize: 15.sp, color: Colors.grey),))
              ],
            ),
          ),

          /// Upcoming Movies ListView
          upcomingMoviesModel == null ? Container() : Container(
            height: 300.h, // Height of the horizontal ListView
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, idx){
                return Padding(
                  padding: const EdgeInsets.all(3),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: (){
                        CustomNavigation.push(context, MovieDetails(id: upcomingMoviesModel!.results!.elementAt(idx).id!));
                      },
                      child: Container(
                        width: 150.w,
                        child: Stack(
                          children: [
                            Image.network('https://image.tmdb.org/t/p/w500/${upcomingMoviesModel!.results!.elementAt(idx).posterPath}',
                                height: 300.h,
                                width: 150.w,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stack){
                                  return Container();
                                }
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 150.h,
                                width: 150.w,// Adjust this height as needed
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.7), // Fading effect
                                    ],
                                    stops: const [0.5, 1.0], // Gradient stop points
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(3,0,3,0),
                              child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child:Text(upcomingMoviesModel!.results!.elementAt(idx).title ??"",
                                    style: GoogleFonts.openSans(
                                        fontSize:16.sp
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget Trending()
  {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          trendingMoviesModel == null ? Container() : Padding(
              padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 4.h),
              child: Row(
                children: [
                  Text("Trending", style: GoogleFonts.raleway(fontSize: 20.sp, fontWeight: FontWeight.bold,),),
                  Spacer(),
                  InkWell(
                      onTap: (){
                        List<MovieResultsModel> movies = trendingMoviesModel!.results!.map((e) {
                          return MovieResultsModel.fromJson(e.toJson());
                        }).toList();
                        CustomNavigation.push(context, SeeAll(movieResultsModel: movies,));
                      },
                      child: Text("See all >>", style: GoogleFonts.lato(fontSize: 15.sp, color: Colors.grey),))
                ],
              )
          ),

          /// Upcoming Movies ListView
          trendingMoviesModel == null ? Container() : Container(
            height: 300.h, // Height of the horizontal ListView
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, idx){
                return Padding(
                  padding: const EdgeInsets.all(3),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: (){
                        CustomNavigation.push(context, MovieDetails(id: trendingMoviesModel!.results!.elementAt(idx).id!));
                      },
                      child: Container(
                        width: 150.w,
                        child: Stack(
                          children: [
                            Image.network(CommonFunctions().getTMDBImage(posterPath: trendingMoviesModel!.results!.elementAt(idx).posterPath!),
                                height: 300.h,
                                width: 150.w,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stack){
                                  return Container();
                                }
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 150.h,
                                width: 150.w,// Adjust this height as needed
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.7), // Fading effect
                                    ],
                                    stops: const [0.5, 1.0], // Gradient stop points
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(3,0,3,0),
                              child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child:Text(trendingMoviesModel!.results!.elementAt(idx).originalTitle!,
                                    style: GoogleFonts.openSans(
                                        fontSize:16.sp
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget Videos()
  {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            trendingMoviesModel == null ? Container() : Padding(
                padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 4.h),
                child: Row(
                  children: [
                    Text("Trending", style: GoogleFonts.raleway(fontSize: 20.sp, fontWeight: FontWeight.bold,),),
                    Spacer(),
                    InkWell(
                        onTap: (){
                          List<MovieResultsModel> movies = trendingMoviesModel!.results!.map((e) {
                            return MovieResultsModel.fromJson(e.toJson());
                          }).toList();
                          CustomNavigation.push(context, SeeAll(movieResultsModel: movies,));
                        },
                        child: Text("See all >>", style: GoogleFonts.lato(fontSize: 15.sp, color: Colors.grey),))
                  ],
                )
            ),

            /// Upcoming Movies ListView
            trendingMoviesModel == null ? Container() : Container(
              height: 300.h, // Height of the horizontal ListView
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, idx){
                  return Padding(
                    padding: const EdgeInsets.all(3),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        onTap: (){
                          CustomNavigation.push(context, MovieDetails(id: trendingMoviesModel!.results!.elementAt(idx).id!));
                        },
                        child: Container(
                          width: 150.w,
                          child: Stack(
                            children: [
                              Image.network(CommonFunctions().getTMDBImage(posterPath: trendingMoviesModel!.results!.elementAt(idx).posterPath!),
                                  height: 300.h,
                                  width: 150.w,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stack){
                                    return Container();
                                  }
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 150.h,
                                  width: 150.w,// Adjust this height as needed
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7), // Fading effect
                                      ],
                                      stops: const [0.5, 1.0], // Gradient stop points
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(3,0,3,0),
                                child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child:Text(trendingMoviesModel!.results!.elementAt(idx).originalTitle!,
                                      style: GoogleFonts.openSans(
                                          fontSize:16.sp
                                      ),
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        )
    );
  }

  fetchNowPlaying()
  async{
    try
    {
      Response response = await Api.fetchNowPlayingMovies();
      if(response.statusCode == 200)
      {
        setState(() {
          nowPlayingMoviesModel = NowPlayingMoviesModel.fromJson(response.data);
        });
        fetchUpcoming();
      }
      else
      {

      }
      return true;
    }
    catch(e)
    {
      String message = e.toString().replaceFirst('Exception: ', '');
      CommonFunctions.printErrorLog(message);
      CommonFunctions().showToast(message);
      return false;
    }
  }

  fetchUpcoming()
  async{
    try
    {
      Response response = await Api.fetchUpcomingMovies();
      if(response.statusCode == 200)
      {
        setState(() {
          upcomingMoviesModel = UpcomingMoviesModel.fromJson(response.data);
        });
        fetchTrending();
      }
      else
      {

      }
      return true;
    }
    catch(e)
    {
      String message = e.toString().replaceFirst('Exception: ', '');
      CommonFunctions.printErrorLog(message);
      CommonFunctions().showToast(message);
      return false;
    }
  }

  fetchTrending()
  async{
    try
    {
      Response response = await Api.fetchTrendingMovies();
      if(response.statusCode == 200)
      {
        setState(() {
          trendingMoviesModel = TrendingMoviesModel.fromJson(response.data);
        });
      }
      else
      {

      }
      return true;
    }
    catch(e)
    {
      String message = e.toString().replaceFirst('Exception: ', '');
      CommonFunctions.printErrorLog(message);
      CommonFunctions().showToast(message);
      return false;
    }
  }

  fetchSearched()
  async{
    try
    {
      Map<String,String> param = {
        "query" : searchMovie
      };
      Response response = await Api.fetchSearchedMovies(param: param);
      if(response.statusCode == 200)
      {
        textEditingController.clear();
        searchMovie="";
        List<MovieResultsModel> movies = (response.data['results'] as List)
            .map((e) => MovieResultsModel.fromJson(e as Map<String, dynamic>))
            .toList();

        if(movies.isEmpty)
          {
            CommonFunctions().showToast("We don't have this movie!");
            return;
          }
        CustomNavigation.push(context, SeeAll(movieResultsModel: movies));
      }
      else
      {
        CommonFunctions().showToast(response.statusMessage??"");
      }
      return true;
    }
    catch(e)
    {
      String message = e.toString().replaceFirst('Exception: ', '');
      CommonFunctions.printErrorLog(message);
      CommonFunctions().showToast(message);
      return false;
    }
}




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchNowPlaying();
    });
  }
  @override
  Widget build(BuildContext context) {
    SizeConstants.setScreenAwareConstant(context);
    return Scaffold(
      body: SafeArea(child:
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                    hintText: "Search",
                    suffixIcon: IconButton(onPressed: (){
                      if(FocusScope.of(context).hasFocus)
                        {
                          FocusScope.of(context).unfocus();
                        }
                      setState(() {});
                      if(searchMovie.isNotEmpty)
                        {
                          fetchSearched();
                        }
                     }, icon: Icon(Icons.arrow_forward_outlined))
                ),
                onChanged: (val){
                   searchMovie = val;
                },
              ),

              Trending(),
              UpComing(),
              NowPlaying()
            ],
          ),
        )
      ),
    );
  }
}

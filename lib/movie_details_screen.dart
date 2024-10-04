import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_recommendation/api_services/api.dart';
import 'package:movie_recommendation/common_utilites/common_functions.dart';
import 'package:movie_recommendation/common_utilites/common_styles.dart';
import 'package:movie_recommendation/common_utilites/common_widgets.dart';
import 'package:movie_recommendation/common_utilites/custom_navigation.dart';
import 'package:movie_recommendation/constants/constants.dart';
import 'package:movie_recommendation/models/imdb_info_model.dart';
import 'package:movie_recommendation/models/movie_collection_model.dart';
import 'package:movie_recommendation/models/movie_details.dart';
import 'package:movie_recommendation/models/movies_cast_model.dart';
import 'package:movie_recommendation/models/video_movie_model.dart';
import 'package:movie_recommendation/play_video.dart';
import 'package:movie_recommendation/profile_info.dart';
import 'package:movie_recommendation/screen_util/screen_util.dart';

class MovieDetails extends StatefulWidget {
  final int id;
  MovieDetails({super.key, required this.id});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {

  MovieDetailsModel? movieDetailsModel;
  MoviesCastModel? movieCastModel;
  MovieCollectionModel? movieCollectionModel;
  VideoMoviesModel? videoMoviesModel;
  IMDBInfoModel? imdbInfoModel;

  bool isLoading = false;

  Future<bool> fetchInfo()
  async{
    try {
      setState(() {
        isLoading = true;
      });
      Response response = await Api.fetchMoviesDetails(id: widget.id);
      if (response.statusCode == 200) {
        movieDetailsModel = MovieDetailsModel.fromJson(response.data);
        isLoading = false;
        if(movieDetailsModel!.belongsToCollection != null)
        {
         await fetchCollection(movieDetailsModel?.belongsToCollection?.id);
         await fetchIMDBInfo(movieDetailsModel?.imdbId);
        }
        setState(() {});
      }
      else {

      }
      fetchCredits();
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

  fetchCredits()
  async{
    try
    {
      Response response = await Api.fetchMovieCredits(id: widget.id);
      if(response.statusCode == 200)
      {
          movieCastModel = MoviesCastModel.fromJson(response.data);
          setState(() {});
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

  fetchCollection(int? collectionId)
  async{
    try
    {
      if(collectionId == null)
      {
        return;
      }
      Response response = await Api.fetchMovieCollection(id: collectionId);
      if(response.statusCode == 200)
      {
        setState(() {movieCollectionModel = MovieCollectionModel.fromJson(response.data);});
      }
      else
      {

      }
      fetchVideos();
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

  fetchVideos()
  async{
    try
    {
      Response response = await Api.fetchVideosOfMovies(movieId: widget.id);
      if(response.statusCode == 200)
      {
        videoMoviesModel = VideoMoviesModel.fromJson(response.data);
        setState(() {});
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

  fetchIMDBInfo(String? imdbId)
  async{
    try
    {
      if(imdbId == null)
        {
          return;
        }

      Map<String, String> params =
      {
        "apikey": Constants.omdbAPIKey,
        "i" : imdbId
      };

      Response response = await Api.fetchIMDBDetails(params: params);
      if(response.statusCode == 200)
      {
        imdbInfoModel = IMDBInfoModel.fromJson(response.data);
        setState(() {});
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

  Widget ShowRatings()
  {
    return imdbInfoModel == null ? Container() : Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("IMDB : " + imdbInfoModel!.imdbRating! ?? "" , style: CommonTextStyles().movieInfoAboutValueStyle()!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 18.sp
        ),),
        ...imdbInfoModel!.ratings!.map((e) {
          if(e.source == "Rotten Tomatoes")
            {
              return  Text(" | Rotten Tomotoes : " + e!.value! ?? "", style: CommonTextStyles().movieInfoAboutValueStyle()!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp
              ),);
            }
          return Text("");
        })
      ],
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConstants.setScreenAwareConstant(context);
    return Scaffold(
      body: SafeArea(
        child: movieDetailsModel==null ? CommonWidgets().Loader():
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              snap: false,
              title: Text(movieDetailsModel!.title??"", style: GoogleFonts.raleway(fontSize: 25.sp, fontWeight: FontWeight.bold,),),
              floating: true,
              expandedHeight: 500.h,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      CommonFunctions().getTMDBImage(posterPath:  movieDetailsModel!.posterPath!),
                      fit: BoxFit.cover,
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: double.infinity,
                        height: 200.h, // Adjust this height as needed
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.8), // Adjust opacity for the fade effect
                            ],
                            stops: const [0.6, .9],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        height: 200.h, // Adjust this height as needed
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.8), // Adjust opacity for the fade effect
                            ],
                            stops: const [0.6, .9],
                          ),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: ShowRatings())
                  ],
                )
              ),
            ),
            SliverList(delegate: SliverChildListDelegate(
              [
                /// Collection Listview
                movieCollectionModel == null? Container() : Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 4.h),
                        child: Text("Collection", style: GoogleFonts.raleway(fontSize: 20.sp, fontWeight: FontWeight.bold,),),
                      ),
                      movieCollectionModel == null? Container() : Container(
                        height: 200.h, // Height of the horizontal ListView
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: movieCollectionModel!.parts!.length,
                          itemBuilder: (context, idx){
                            return Padding(
                              padding: const EdgeInsets.all(3),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  width: 150.w,
                                  child: Stack(
                                    children: [
                                      Image.network('https://image.tmdb.org/t/p/w500/${movieCollectionModel!.parts!.elementAt(idx).posterPath}',
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
                                          height: 100.h,
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
                                            child:Text(movieCollectionModel!.parts!.elementAt(idx).originalTitle??"")),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                /// Cast Listview Widget
                movieCastModel == null? Container() : Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 4.h),
                        child: Text("Cast", style: GoogleFonts.raleway(fontSize: 20.sp, fontWeight: FontWeight.bold,),),
                      ),
                      movieCastModel == null? Container() : Container(
                        height: 200.h,// Height of the horizontal ListView
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: movieCastModel?.cast!.length,
                          itemBuilder: (context, idx){
                            return Padding(
                              padding: const EdgeInsets.all(3),
                              child: InkWell(
                                onTap: (){
                                    if(movieCastModel!.cast!.elementAt(idx).id != null)
                                      {
                                        CustomNavigation.push(context, Profile(id: movieCastModel!.cast!.elementAt(idx).id!.toString()));
                                      }
                                    else
                                      {
                                        CommonFunctions().showToast("No data available!");
                                      }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Stack(
                                    children: [
                                      Image.network(CommonFunctions().getTMDBImage(posterPath: movieCastModel!.cast!.elementAt(idx).profilePath??""),
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
                                          height: 100.h,
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
                                            child:Text(movieCastModel!.cast!.elementAt(idx).name??"",)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                /// Video Listview Widget
                videoMoviesModel == null? Container() : Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 4.h),
                        child: Text("Videos", style: GoogleFonts.raleway(fontSize: 20.sp, fontWeight: FontWeight.bold,),),
                      ),
                      videoMoviesModel == null ? Container() : Container(
                        height: 200.h,// Height of the horizontal ListView
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: videoMoviesModel!.results == null ? 0 : videoMoviesModel!.results!.length,
                          itemBuilder: (context, idx){
                            return Padding(
                              padding: const EdgeInsets.all(3),
                              child: InkWell(
                                onTap: (){
                                  CustomNavigation.push(context, VideoPlayerScreen(videoKey: videoMoviesModel!.results!.elementAt(idx).key!));
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Stack(
                                    children: [
                                      Image.network(CommonFunctions().getThumbnailUrl(videoMoviesModel!.results!.elementAt(idx).key!),
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
                                          height: 100.h,
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
                                      Container(
                                        width: 150.w,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(3,0,3,0),
                                          child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child:Text(videoMoviesModel!.results!.elementAt(idx).type??"")),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                /// About Widget
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 8.w, 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 4.h),
                        child: Text("About", style: GoogleFonts.raleway(fontSize: 20.sp, fontWeight: FontWeight.bold,),),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 4.h),
                        child: Table(
                          columnWidths: const {
                            0 : FlexColumnWidth(4),
                            1 : FlexColumnWidth(6),
                          },
                          children: [
                            TableRow(
                              children: [
                                Text("Title ", style: CommonTextStyles().movieInfoAboutKeyStyle(),),
                                Text(movieDetailsModel?.title ?? "", style: CommonTextStyles().movieInfoAboutValueStyle(),),
                              ]
                            ),
                            CommonWidgets().TableSpacing(),
                            TableRow(
                                children: [
                                  Text("Status ", style: CommonTextStyles().movieInfoAboutKeyStyle()),
                                  Text(movieDetailsModel?.status ?? "", style: CommonTextStyles().movieInfoAboutValueStyle())
                                ]
                            ),
                            CommonWidgets().TableSpacing(),
                            TableRow(
                                children: [
                                  Text("Runtime ", style: CommonTextStyles().movieInfoAboutKeyStyle()),
                                  Text(CommonFunctions().convertMinutesToHours(movieDetailsModel!.runtime) ?? "", style: CommonTextStyles().movieInfoAboutValueStyle())
                                ]
                            ),
                            CommonWidgets().TableSpacing(),
                            TableRow(
                                children: [
                                  Text("Genre ", style: CommonTextStyles().movieInfoAboutKeyStyle()),
                                  Wrap(
                                    children: [
                                      ...List.generate(movieDetailsModel!.genres!.length, (index) => Text(movieDetailsModel!.genres!.elementAt(index).name??"" + ", " ,
                                      style: CommonTextStyles().movieInfoAboutValueStyle(),
                                      )),
                                    ],
                                  )
                                ]
                            ),
                            CommonWidgets().TableSpacing(),
                            TableRow(
                                children: [
                                  Text("Premiere ", style: CommonTextStyles().movieInfoAboutKeyStyle()),
                                  Text(CommonFunctions().formatDate(movieDetailsModel!.releaseDate) ?? "", style: CommonTextStyles().movieInfoAboutValueStyle())
                                ]
                            ),
                            CommonWidgets().TableSpacing(),
                            TableRow(
                                children: [
                                  Text("Budget ", style: CommonTextStyles().movieInfoAboutKeyStyle()),
                                  Text(CommonFunctions().amountFormatter(movieDetailsModel!.budget)?? "", style: CommonTextStyles().movieInfoAboutValueStyle())
                                ]
                            ),
                            CommonWidgets().TableSpacing(),
                            TableRow(
                                children: [
                                  Text("Revenue ", style: CommonTextStyles().movieInfoAboutKeyStyle()),
                                  Text(CommonFunctions().amountFormatter(movieDetailsModel!.revenue) ?? "", style: CommonTextStyles().movieInfoAboutValueStyle())
                                ]
                            ),
                            CommonWidgets().TableSpacing(),
                            // TableRow(
                            //     children: [
                            //       Text("Homepage ", style: CommonTextStyles().movieInfoAboutKeyStyle()),
                            //       Text(movieDetailsModel?.homepage ?? "", style: CommonTextStyles().movieInfoAboutValueStyle())
                            //     ]
                            // )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /// IMDB Rating Widget
                imdbInfoModel == null ? Container() : Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 8.w, 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 4.h),
                        child: Text("Rating", style: GoogleFonts.raleway(fontSize: 20.sp, fontWeight: FontWeight.bold,),),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 4.h),
                        child: Table(
                          columnWidths: const {
                            0 : FlexColumnWidth(4),
                            1 : FlexColumnWidth(6),
                          },
                          children: [
                            TableRow(
                                children: [
                                  Text("IMDB Rating", style: CommonTextStyles().movieInfoAboutKeyStyle(),),
                                  Row(
                                    children: [
                                      Text(imdbInfoModel?.imdbRating ?? "", style: CommonTextStyles().movieInfoAboutValueStyle(),),
                                      Text(" ( Votes ${imdbInfoModel?.imdbVotes})", style: CommonTextStyles().movieInfoAboutValueStyle()!.copyWith(
                                        color: Colors.grey
                                      ))
                                    ],
                                  ),
                                ]
                            ),
                            CommonWidgets().TableSpacing(),
                            // TableRow(
                            //     children: [
                            //       Text("IMDB Votes ", style: CommonTextStyles().movieInfoAboutKeyStyle()),
                            //       Text(imdbInfoModel?.imdbVotes ?? "", style: CommonTextStyles().movieInfoAboutValueStyle())
                            //     ]
                            // ),
                            ...imdbInfoModel!.ratings!.map((detail) {
                              return TableRow(
                                  children: [
                                    Text(detail.source??"", style: CommonTextStyles().movieInfoAboutKeyStyle()),
                                    Text(detail.value??"", style: CommonTextStyles().movieInfoAboutValueStyle())
                                  ]
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                )

              ]
            ))
          ],
        ),
      ),
    );
  }
}

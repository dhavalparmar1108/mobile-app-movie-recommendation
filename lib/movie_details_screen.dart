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
import 'package:movie_recommendation/models/movie_details.dart';
import 'package:movie_recommendation/models/movies_cast_model.dart';
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
  bool isLoading = false;
  Future<bool> fetchInfo()
  async{
    try {
      setState(() {
        isLoading = true;
      });
      Response response = await Api.fetchMoviesDetails(id: widget.id);
      CommonFunctions.printLog(response.toString());
      if (response.statusCode == 200) {
        setState(() {
          movieDetailsModel = MovieDetailsModel.fromJson(response.data);
          isLoading = false;
        });
      }
      else {

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

  fetchCredits()
  async{
    try
    {
      Response response = await Api.fetchMovieCredits(id: widget.id);
      CommonFunctions.printLog(response.toString());
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchInfo();
      fetchCredits();
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
              title: Text(movieDetailsModel!.title??""),
              floating: true,
              expandedHeight: 500.h,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      'https://image.tmdb.org/t/p/w500/${movieDetailsModel!.posterPath}',
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
                            stops: [0.6, .9],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ),
            ),
            SliverList(delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: EdgeInsets.fromLTRB(8.w ,8.w, 8.w, 8.w),
                  child: Text(movieDetailsModel!.overview!, style: GoogleFonts.nunitoSans(
                    fontSize: 18.sp
                  ),),
                ),
                Container(
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
                        height: 200.h, // Height of the horizontal ListView
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: movieCastModel?.cast!.length,
                          itemBuilder: (context, idx){
                            return Padding(
                              padding: const EdgeInsets.all(3),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Stack(
                                  children: [
                                    Image.network('https://image.tmdb.org/t/p/w500/${movieCastModel!.cast!.elementAt(idx).profilePath}',
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
                                            stops: [0.5, 1.0], // Gradient stop points
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(3,0,3,0),
                                      child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child:Text(movieCastModel!.cast!.elementAt(idx).name??"")),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
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
                          columnWidths: {
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
                            TableRow(
                                children: [
                                  Text("Status ", style: CommonTextStyles().movieInfoAboutKeyStyle()),
                                  Text(movieDetailsModel?.status ?? "", style: CommonTextStyles().movieInfoAboutValueStyle())
                                ]
                            ),
                            TableRow(
                                children: [
                                  Text("Runtime ", style: CommonTextStyles().movieInfoAboutKeyStyle()),
                                  Text(CommonFunctions().convertMinutesToHours(movieDetailsModel!.runtime!) ?? "", style: CommonTextStyles().movieInfoAboutValueStyle())
                                ]
                            ),
                            TableRow(
                                children: [
                                  Text("Genre ", style: CommonTextStyles().movieInfoAboutKeyStyle()),
                                  Text("", style: CommonTextStyles().movieInfoAboutValueStyle())
                                ]
                            ),
                            TableRow(
                                children: [
                                  Text("Premiere ", style: CommonTextStyles().movieInfoAboutKeyStyle()),
                                  Text(movieDetailsModel?.releaseDate ?? "", style: CommonTextStyles().movieInfoAboutValueStyle())
                                ]
                            ),
                            TableRow(
                                children: [
                                  Text("Budget ", style: CommonTextStyles().movieInfoAboutKeyStyle()),
                                  Text(movieDetailsModel?.budget.toString() ?? "", style: CommonTextStyles().movieInfoAboutValueStyle())
                                ]
                            ),
                            TableRow(
                                children: [
                                  Text("Revenue ", style: CommonTextStyles().movieInfoAboutKeyStyle()),
                                  Text(movieDetailsModel?.revenue.toString() ?? "", style: CommonTextStyles().movieInfoAboutValueStyle())
                                ]
                            ),
                            TableRow(
                                children: [
                                  Text("Homepage ", style: CommonTextStyles().movieInfoAboutKeyStyle()),
                                  Text(movieDetailsModel?.homepage ?? "", style: CommonTextStyles().movieInfoAboutValueStyle())
                                ]
                            )
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

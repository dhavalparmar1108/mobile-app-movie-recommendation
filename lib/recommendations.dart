import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_recommendation/models/movies_list.dart';
import 'package:movie_recommendation/movie_details_screen.dart';

class Recommendations extends StatefulWidget {
  final MoviesList moviesList;
  final String movie;
  const Recommendations({super.key, required this.moviesList, required this.movie});

  @override
  State<Recommendations> createState() => _RecommendationsState();
}

class _RecommendationsState extends State<Recommendations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:  Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(8.w, 4.h, 4.h, 4.w),
                child: SelectableText("Similar to: " + widget.movie,
                  style: GoogleFonts.raleway(fontSize: 25.sp, fontWeight: FontWeight.bold,),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(shrinkWrap: true, itemBuilder: (context, idx){
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetails(id:
                    widget.moviesList.recommendedId!.elementAt(idx))));
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(12.w, 4.h, 4.h, 12.w),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: SelectableText("${idx+1}. "+ widget.moviesList.recommendedMovies!.elementAt(idx),
                              style: GoogleFonts.raleway(fontSize: 20.sp, fontWeight: FontWeight.bold,),
                          ),
                        ),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: InteractiveViewer(child: Image.network(widget.moviesList.recommendedPosters!.elementAt(idx)))),

                        SizedBox(height: 5.h,),
                        SelectableText(
                            widget.moviesList.recommendedOverview!.elementAt(idx), style: GoogleFonts.nunitoSans(
                            fontSize: 18.sp
                        )),
                        SizedBox(height: 10.h,),
                        Align(
                          alignment: Alignment.topLeft,
                          child: SelectableText(
                              widget.moviesList.recommendedGenre!.elementAt(idx), style: GoogleFonts.nunitoSans(
                              fontWeight: FontWeight.bold, fontSize: 18.sp
                          )),
                        ),
                        Divider(height: 5.h,),
                      ],
                    ),
                  ),
                );
              }, itemCount: widget.moviesList.recommendedMovies!.length,),
            ),
          ],
        )
      ),
    );
  }
}

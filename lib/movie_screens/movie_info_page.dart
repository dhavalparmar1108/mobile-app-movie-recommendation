import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_recommendation/models/movie_details.dart';
import 'package:movie_recommendation/models/movie_results_model.dart';
import 'package:movie_recommendation/models/movies_list.dart';
import 'package:movie_recommendation/movie_details_screen.dart';

class SeeAll extends StatefulWidget {
  final List<MovieResultsModel> movieResultsModel;
  SeeAll({super.key, required this.movieResultsModel});

  @override
  State<SeeAll> createState() => _SeeAllState();
}

class _SeeAllState extends State<SeeAll> {

  List<MovieResultsModel> movies = <MovieResultsModel>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    movies.addAll(widget.movieResultsModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child:  Column(
            children: [
              SizedBox(height: 5.h,),
              Expanded(
                child: ListView.builder(shrinkWrap: true, itemBuilder: (context, idx){
                  return InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetails(id:
                      movies.elementAt(idx).id!)));
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(12.w, 4.h, 4.h, 12.w),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: SelectableText("${idx+1}. "+ movies.elementAt(idx).title!,
                              style: GoogleFonts.raleway(fontSize: 20.sp, fontWeight: FontWeight.bold,),
                            ),
                          ),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: InteractiveViewer(child: movies.elementAt(idx).posterPath == null? Container():Image.network("https://image.tmdb.org/t/p/w500/"+movies.elementAt(idx).posterPath!))),
                          SizedBox(height: 5.h,),
                          SelectableText(
                              movies.elementAt(idx).overview!, style: GoogleFonts.nunitoSans(
                              fontSize: 18.sp
                          )),
                          SizedBox(height: 10.h,),
                          Divider(height: 5.h,),
                        ],
                      ),
                    ),
                  );
                }, itemCount: movies.length,),
              ),
            ],
          )
      ),
    );
  }
}

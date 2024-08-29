import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_recommendation/api_services/api.dart';
import 'package:movie_recommendation/common_utilites/common_functions.dart';
import 'package:movie_recommendation/common_utilites/common_styles.dart';
import 'package:movie_recommendation/common_utilites/common_widgets.dart';
import 'package:movie_recommendation/models/person_info_model.dart';

class Profile extends StatefulWidget {
  String id;
  Profile({super.key, required this.id});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  PersonInfoModel? personInfoModel;

  fetchDetails()
  async{
    try
    {
      Response response = await Api.fetchPersonDetails(id: widget.id);
      if(response.statusCode == 200)
      {
          personInfoModel = PersonInfoModel.fromJson(response.data);
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: personInfoModel == null ? Center(child: CommonWidgets().Loader()): SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: Icon(Icons.arrow_back)),
                    SizedBox(width: 10.w,),
                    Text(personInfoModel!.name!, style: GoogleFonts.raleway(fontSize: 25.sp, fontWeight: FontWeight.bold,),)
                  ],
                ),
                SizedBox(height: 10.h,),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 300.h,
                    minWidth: 250.h
                  ),
                  child: Container(
                    height: 300.h,
                    width: 250.h,
                    child: ClipOval(
                      clipBehavior : Clip.antiAlias,
                      child: Material(
                        elevation: 20,
                        shadowColor: Colors.blueGrey,
                        child: Container(
                          child: Image.network(
                              fit: BoxFit.cover,
                              CommonFunctions().getTMDBImage(posterPath: personInfoModel!.profilePath!)),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h,),
                Text(personInfoModel!.biography!, style: GoogleFonts.lato(
                  fontSize : 15.sp
                ),),
                SizedBox(height: 20.h,),
                Table(
                  columnWidths: const {
                    0 : FlexColumnWidth(4),
                    1 : FlexColumnWidth(6),
                  },
                  children: [
                    TableRow(
                      children: [
                        Text("Name", style: CommonTextStyles().movieInfoAboutKeyStyle(),),
                        Text(personInfoModel!.name??"NA", style: CommonTextStyles().movieInfoAboutValueStyle(),)
                      ]
                    ),
                    TableRow(
                        children: [
                          Text("Birthday", style: CommonTextStyles().movieInfoAboutKeyStyle(),),
                          Text(CommonFunctions().formatDate(personInfoModel!.birthday), style: CommonTextStyles().movieInfoAboutValueStyle())
                        ]
                    ),
                    TableRow(
                        children: [
                          Text("Death", style: CommonTextStyles().movieInfoAboutKeyStyle(),),
                          Text(CommonFunctions().formatDate(personInfoModel!.deathday), style: CommonTextStyles().movieInfoAboutValueStyle())
                        ]
                    ),
                    TableRow(
                        children: [
                          Text("Birth Place", style: CommonTextStyles().movieInfoAboutKeyStyle(),),
                          Text(personInfoModel!.placeOfBirth??"NA", style: CommonTextStyles().movieInfoAboutValueStyle())
                        ]
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonTextStyles
{
   TextStyle? movieInfoAboutKeyStyle(){
     return GoogleFonts.montserrat(
       color: Colors.grey,
       fontSize: 14.sp
     );
   }

   TextStyle? movieInfoAboutValueStyle(){
     return GoogleFonts.montserrat(
         color: Colors.white,
         fontSize: 14.sp,
     );
   }
}
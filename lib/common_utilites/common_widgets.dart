import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonWidgets
{
  Widget Loader()
  {
    return AbsorbPointer(
      absorbing: true,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: .1, sigmaY: .1),
        child: Center(
          child: Container(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  TableRow TableSpacing()
  {
    return TableRow(
      children: [
        SizedBox(height: 5.h),
        SizedBox(height: 5.h,)// Adds spacing between rows
      ],
    );  }
}
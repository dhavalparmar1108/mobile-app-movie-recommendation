import 'dart:ui';

import 'package:flutter/material.dart';

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
}
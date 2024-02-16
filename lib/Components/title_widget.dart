import 'package:fypuser/Color/color.dart';
import 'package:flutter/material.dart';

class TitleWidget {
  ///Title Widget
  static Widget title(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 16),
      child: Text(
        text,
        style: TextStyle(
          shadows: <Shadow>[
            Shadow(
              offset: const Offset(3.0, 3.0),
              blurRadius: 20.0,
              color: Colors.greenAccent.withOpacity(0.5),
            ),
          ],
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: CustomColors.primaryColor,
        ),
      ),
    );
  }
}

class BarTitle {
  static Widget AppBarText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        text,
        style: TextStyle(
          shadows: <Shadow>[
            Shadow(
              offset: const Offset(4.0, 4.0),
              blurRadius: 20.0,
              color: CustomColors.defaultWhite.withOpacity(0.5),
            ),
          ],
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: CustomColors.primaryColor,
        ),
      ),
    );
  }
}


class SubTitle{
  static subTitle(String text){
    return Padding(
      padding: const EdgeInsets.fromLTRB(16,0,16,16),
      // padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 16),
      child: Text(
        text,
        style: const TextStyle(
          fontStyle: FontStyle.normal,
            fontSize: 25,
            fontWeight: FontWeight.w400,
            color: CustomColors.defaultBlack
        ),
      ),
    );
  }
}

class OrderTitle{
  static orderTitle(String text, double fontSize, fontWeight){
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 14, 16),
    child: Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight
      ),
    ),
    );
  }
}

class Totaltitle{
  static totalTitle(String text, double fontSize, fontWeight){
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 14, 16),
      child: Text(
        text,
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight
        ),
      ),
    );
  }
}

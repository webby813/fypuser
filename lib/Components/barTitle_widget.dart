import 'package:fypuser/Color/color.dart';
import 'package:flutter/material.dart';

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

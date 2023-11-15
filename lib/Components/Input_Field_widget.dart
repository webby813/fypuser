import 'package:flutter/material.dart';

TextEditingController password = TextEditingController();

class InputWidget{
  static Widget inputField(String hint, IconData iconData, var controller) {
    return SizedBox(
      height: 50,
      child: Material(
        elevation: 8,
        shadowColor: Colors.black87,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        child: TextField(
          controller: controller,
          obscureText: (controller == password) ? true : false,
          textAlignVertical: TextAlignVertical.bottom,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            prefixIcon: Icon(iconData),
          ),
        ),
      ),
    );
  }
}

class PasswordInputWidget {
  static bool hideText = true;

  static Widget passwordInput(String hint, IconData iconData, var controller) {
    return SizedBox(
      height: 50,
      child: Material(
        elevation: 8,
        shadowColor: Colors.black87,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        child: TextField(
          controller: controller,
          obscureText: hideText,
          textAlignVertical: TextAlignVertical.bottom,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            prefixIcon: IconButton(
              icon: Icon(iconData),
              onPressed: () {
                  hideText = !hideText;
              },
            ),
          ),
        ),
      ),
    );
  }
}


/// <----- auth_page_widgets.dart ----->
///
/// Login ekranında e-mail ve password
/// kutularını gösteren metod
///
library;

import 'package:flutter/material.dart';

import '../../constants/app_constants/constants.dart';

class AuthPageWidgets {
  static Container buildLoginTextField(
      String hintText,
      IconData prefixIcon, {
        bool obscureText = false,
        TextInputType? keyboardType,
        Function(String)? onChanged,
        bool isFirst = false,
        TextEditingController? controller,
      }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              width: 2,
              color: isFirst ? menuColor : menuColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.white,
            ),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: menuColor,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
        cursorColor: Colors.white,
        keyboardType: keyboardType,
      ),
    );
  }
}

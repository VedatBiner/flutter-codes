import 'package:flutter/material.dart';
import '../methods.dart';

InkWell actionBtn(Function() click, IconData icon) {
  return InkWell(
    onTap: () => click(),
    child: Container(
      width: 60,
      height: 60,
      margin: const EdgeInsets.only(bottom: 20, top: 5),
      decoration: BoxDecoration(
          color: Color(
            RenkMetod.HexaColorConverter("#DCD2FF"),
          ),
          shape: BoxShape.circle),
      child: Icon(
        icon,
        size: 32,
      ),
    ),
  );
}


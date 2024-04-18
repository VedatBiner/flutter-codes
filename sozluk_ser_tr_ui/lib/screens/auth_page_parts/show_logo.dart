/// <----- show_logo.dart ----->
///

library;
import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    /// login ekranında logo gösteren metod
    return Center(
      child: CircleAvatar(
        radius: 100,
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.amber,
                blurRadius: 10.0,
                spreadRadius: 2.0,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: const CircleAvatar(
            radius: 100,
            backgroundImage: AssetImage(
              "assets/images/maymuncuk.jpg",
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {

  final Color color;
  final Color textColor;
  final String buttonText;
  final buttonTapped;

  const MyButton({
    super.key,
    required this.color,
    required this.textColor,
    required this.buttonText,
    required this.buttonTapped
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonTapped,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
            child: Container(
              color: color,
              child: Center(
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
        ),
      ),
    );
  }
}










import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {

  final Color color;
  final Color textColor;
  final String buttonText;

  const MyButton({
    super.key,
    required this.color,
    required this.textColor,
    required this.buttonText
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                ),
              ),
            ),
          ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget {

  final Color renk;
  final Widget child;
  // final Function onPress; Bu kod null safety için geçersiz.
  final VoidCallback onPress; // bunu kullanmak gerekiyor.
  const MyContainer({Key? key, this.renk = Colors.white, required this.child, required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: renk,
        ),
        child: child,
      ),
    );
  }
}

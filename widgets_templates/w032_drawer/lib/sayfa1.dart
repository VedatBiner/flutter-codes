import 'package:flutter/material.dart';

class SayfaBir extends StatefulWidget {
  const SayfaBir({Key? key}) : super(key: key);

  @override
  State<SayfaBir> createState() => _SayfaBirState();
}

class _SayfaBirState extends State<SayfaBir> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Sayfa Bir",
        style: TextStyle(
          color: Colors.black54,
          fontSize: 36,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Butonlar extends StatelessWidget {
  final void Function(int) handlePuanEkle;
  const Butonlar({Key? key, required this.handlePuanEkle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (int j = 0; j < 5; j++)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = j * 4 + 1; i <= j * 4 + 4; i++)
                if (i <= 20)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          handlePuanEkle(i * 10);
                        },
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(
                            const Size(56.0, 56.0),
                          ),
                          shape:
                              MaterialStateProperty.all<CircleBorder>(
                            const CircleBorder(),
                          ),
                        ),
                        child: Text(
                          "${i * 10}",
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
            ],
          ),
      ],
    );
  }
}

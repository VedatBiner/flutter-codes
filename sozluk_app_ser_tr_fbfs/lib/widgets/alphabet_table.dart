///<----- alphabet_table.dart ----->
import 'package:flutter/material.dart';

class AlphabetTable extends StatelessWidget {
  final List<Map> alphabet;

  const AlphabetTable({
    Key? key,
    required this.alphabet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(30),
          1: FlexColumnWidth(50),
        },
        children: alphabet.map((latin) {
          return TableRow(children: [
            Container(
              color: alphabet.indexOf(latin) % 2 == 0
                  ? Colors.blue[50]
                  : Colors.amber[50],
              padding: const EdgeInsets.all(10),
              child: Text(
                latin['turkce'].toString(),
                style: alphabet.indexOf(latin) == 0
                    ? const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )
                    : const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
              ),
            ),
            Container(
              color: alphabet.indexOf(latin) % 2 == 0
                  ? Colors.blue[50]
                  : Colors.amber[50],
              padding: const EdgeInsets.all(10),
              child: Text(
                latin['sirpca'],
                style: alphabet.indexOf(latin) == 0
                    ? const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )
                    : const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
              ),
            )
          ]);
        }).toList(),
        border: TableBorder.all(width: 1, color: Colors.black),
      ),
    );
  }
}

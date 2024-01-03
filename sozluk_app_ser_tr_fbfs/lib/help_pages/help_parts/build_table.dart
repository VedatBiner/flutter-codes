import 'package:flutter/material.dart';

import '../../constants.dart';

Widget buildTable(
    List<Map<String, String>> pageSample,
    String baslik,
    String Function(Map<String, String>) getFirstColumn,
    String Function(Map<String, String>) getSecondColumn,
    ) {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: SingleChildScrollView(
      child: Column(
        children: [
          Text(
            baslik,
            style: baslikTextBlack87,
            textAlign: TextAlign.left,
          ),
          Table(
            columnWidths: const {
              0: IntrinsicColumnWidth(),
              1: IntrinsicColumnWidth(),
            },
            children: pageSample.map((user) {
              String firstColumn = getFirstColumn(user) ?? ''; // Null kontrolü ekledik
              String secondColumn = getSecondColumn(user) ?? ''; // Null kontrolü ekledik
              return TableRow(
                children: [
                  Container(
                    color: pageSample.indexOf(user) % 2 == 0
                        ? Colors.blue[50]
                        : Colors.amber[50],
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      firstColumn,
                      style: pageSample.indexOf(user) == 0
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
                    color: pageSample.indexOf(user) % 2 == 0
                        ? Colors.blue[50]
                        : Colors.amber[50],
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      secondColumn,
                      style: pageSample.indexOf(user) == 0
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
                ],
              );
            }).toList(),
            border: TableBorder.all(width: 1, color: Colors.black),
          ),
        ],
      ),
    ),
  );
}

import 'package:flutter/material.dart';

import '../../constants.dart';

Widget buildCogulTable(
  List<Map<String, String>> pageSample,
  String baslik,
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
              return TableRow(
                children: [
                  Container(
                    color: pageSample.indexOf(user) % 2 == 0
                        ? Colors.blue[50]
                        : Colors.amber[50],
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      user['tekil']!,
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
                      user['çoğul']!,
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

/// <----- build_table.dart ----->
library;

import 'package:flutter/material.dart';

// import '../../constants/app_constants/constants.dart';

Widget buildTable(
  List<Map<String, String>> pageSample,
  String baslik,
  List<String Function(Map<String, String>)> getColumnValues,
) {
  return Padding(
    padding: const EdgeInsets.all(12),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            baslik,
            //  style: androidTextStyle,
            textAlign: TextAlign.left,
          ),
          Table(
            columnWidths: {
              for (var index in List.generate(
                getColumnValues.length,
                (index) => index,
              ))
                index: const IntrinsicColumnWidth(),
            },
            children: [
              TableRow(
                decoration: const BoxDecoration(color: Colors.indigo),
                children:
                    getColumnValues.map((getColumnValue) {
                      String columnHeader =
                          getColumnValue(pageSample.first) ?? '';
                      return Container(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          columnHeader,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }).toList(),
              ),

              /// Kontrol eklendi, başlık satırıyla ikinci satır
              /// eşitse üçüncü satırı yazma
              if (getColumnValues.every(
                (getColumnValue) =>
                    getColumnValue(pageSample.first) !=
                    getColumnValue(pageSample[1]),
              ))
                ...pageSample
                    .getRange(1, pageSample.length)
                    .map(
                      (user) => TableRow(
                        decoration: BoxDecoration(
                          color:
                              pageSample.indexOf(user) % 2 == 0
                                  ? Colors.lightBlue.shade50
                                  : Colors.amber.shade50,
                        ),
                        children:
                            getColumnValues.map((getColumnValue) {
                              String columnValue = getColumnValue(user) ?? '';
                              return Container(
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  columnValue,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              );
                            }).toList(),
                      ),
                    ),
            ],
            border: TableBorder.all(width: 1, color: Colors.black),
          ),
        ],
      ),
    ),
  );
}

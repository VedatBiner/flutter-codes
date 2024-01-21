/// <----- build_table.dart ----->

import 'package:flutter/material.dart';

import '../../constants/app_constants/constants.dart';

Widget buildTable(
  BuildContext context,
  List<Map<String, String>> pageSample,
  String baslik,
  List<String Function(Map<String, String>)> getColumnValues,
) {
  return Padding(
    padding: const EdgeInsets.all(12),
    child: SingleChildScrollView(
      child: Column(
        children: [
          Text(
            baslik,
            style: Theme.of(context).platform == TargetPlatform.android
                ? androidTextStyle
                : webTextStyle,
            textAlign: TextAlign.left,
          ),
          Table(
            columnWidths: {
              for (var index
                  in List.generate(getColumnValues.length, (index) => index))
                index: const IntrinsicColumnWidth(),
            },
            children: [
              TableRow(
                decoration: const BoxDecoration(
                  color: Colors.indigo,
                ),
                children: getColumnValues.map((getColumnValue) {
                  String columnHeader = getColumnValue(pageSample.first) ?? '';
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
              for (var user in pageSample)
                TableRow(
                  decoration: BoxDecoration(
                    color: pageSample.indexOf(user) % 2 == 0
                        ? Colors.lightBlue.shade50
                        : Colors.amber.shade50,
                  ),
                  children: getColumnValues.map((getColumnValue) {
                    String columnValue = getColumnValue(user) ?? '';
                    return Container(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        columnValue,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
            border: TableBorder.all(
              width: 1,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ),
  );
}

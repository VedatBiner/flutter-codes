import 'package:flutter/material.dart';

Widget buildTable(
    List<Map<String, String>> pageSample,
    String baslik,
    List<String Function(Map<String, String>)> getColumnValues,
    ) {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: SingleChildScrollView(
      child: Column(
        children: [
          Text(
            baslik,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.left,
          ),
          Table(
            columnWidths: Map.fromIterable(
              List.generate(getColumnValues.length, (index) => index),
              key: (index) => index,
              value: (_) => IntrinsicColumnWidth(),
            ),
            children: pageSample.map((user) {
              List<Widget> columns = getColumnValues.map((getColumnValue) {
                String columnValue = getColumnValue(user) ?? '';
                return Container(
                  color: pageSample.indexOf(user) % 2 == 0
                      ? Colors.blue[50]
                      : Colors.amber[50],
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    columnValue,
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
                );
              }).toList();

              return TableRow(children: columns);
            }).toList(),
            border: TableBorder.all(width: 1, color: Colors.black),
          ),
        ],
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weight_tracker_app/widgets/record_list_tile.dart';
import '../models/record.dart';
import '../view-models/controller.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final Controller _controller = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    List<Record> records = _controller.records;
    return Obx(() => Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("History"),
            actions: [
              IconButton(
                onPressed: _controller.addRecord,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          // Verilerin otomatik güncellenmesi
          body: records.isEmpty
              ? const Center(
                  child: Text(
                    "Please add some records",
                  ),
                )
              : ListView(
                  physics: const BouncingScrollPhysics(),
                  children: records
                      .map((record) => RecordListTile(record: record))
                      .toList(),
                ),
        ));
  }
}









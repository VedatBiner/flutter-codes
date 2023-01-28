import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weight_tracker_app/views/add_record.dart';
import '../views/graph.dart';
import '../views/history.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentTab = 0;
  // uygulama bu ekran ile açılacak
  Widget _currentScreen = const GraphScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Track Your Weight")),
      body: _currentScreen,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Get.to(() => const AddRecordView());
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        height: Get.height / 12,
        activeColor: Colors.white,
        inactiveColor: Colors.grey,
        gapLocation: GapLocation.center,
        iconSize: 30,
        backgroundColor: Colors.black,
        icons: const [Icons.show_chart, Icons.history],
        activeIndex: _currentTab,
        onTap: (int) {
          setState(() {
            _currentTab = int;
            _currentScreen = (int == 0) ? const GraphScreen() : const HistoryScreen();
          });
        },
      ),
    );
  }
}

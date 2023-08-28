import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/controller/main_screen_controller.dart';
import '../../core/page_model/drawer_menu_model.dart';

class DrawerMenuListWidget extends StatelessWidget {
  const DrawerMenuListWidget(this.model, {super.key});
  final DrawerMenuModel model;

  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenController>(builder: (context, provider, child) {
      return InkWell(
        onTap: model.clicked,
        child: SizedBox(
          width: 200,
          height: 80,
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    model.icon,
                    size: provider.currentPage == model.pageNumber ? 48 : 36,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    model.title ?? "",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              provider.currentPage != model.pageNumber
                  ? const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    )
                  : const Divider(
                      color: Colors.red,
                      thickness: 2,
                    ),
            ],
          ),
        ),
      );
    });
  }
}

/*
Future<void> pageAnimatedTo(int page) async {
  MainScreenController.instance.changePage(page);
  return MainScreenController.instance.controller.animateToPage(
    page,
    duration: PageDuration().durationMs300,
    curve: Curves.bounceIn,
  );
}

 */

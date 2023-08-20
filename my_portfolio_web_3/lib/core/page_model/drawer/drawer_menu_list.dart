import 'package:flutter/material.dart';
import 'package:my_portfolio_web_3/core/constants/duration.dart';
import 'drawer_menu_model.dart';

Widget drawerMenuListWidget(DrawerMenuModel e) {
  return InkWell(
    onTap: e.clicked,
    child: SizedBox(
      width: 200,
      height: 80,
      child: Column(
        children: [
          Row(
            children: [
              Icon(e.icon, size: 36),
              const SizedBox(width: 16),
              Text(
                e.title ?? "",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
            ],
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ],
      ),
    ),
  );
}

Future<void> pageAnimatedTo(int page, PageController cont) {
  return cont.animateToPage(
    page,
    duration: PageDuration().durationMs300,
    curve: Curves.bounceIn,
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/constants.dart';
import '../models/navitem.dart';
import '../size_config.dart';

class MyBottomNavBar extends StatelessWidget {
  const MyBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    double? defaultSize = SizeConfig.defaultSize;
    return Consumer<NavItems>(
      builder: (context, navItems, child) => Container(
        padding: EdgeInsets.symmetric(horizontal: defaultSize! * 3),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -7),
              blurRadius: 30,
              color: const Color(0xFF4B1A39).withOpacity(0.2),
            )
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
                navItems.items.length,
                (index) => buildIconNavBarItem(
                      isActive:
                          navItems.items.selectedIndex == index ? true : false,
                      icon: navItems.items[index].icon,
                      press: () {
                        navItems.changeNavIndex(index: index);
                        if (navItems.items[index].destinationChecker()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  navItems.items[index].destination,
                            ),
                          );
                        }
                      },
                    )),
          ),
        ),
      ),
    );
  }

  IconButton buildIconNavBarItem({
    required String icon,
    required Function press,
    bool isActive = false,
  }) {
    return IconButton(
      icon: SvgPicture.asset(
        icon,
        color: isActive ? kPrimaryColor : const Color(0xFFDAD4),
        height: 22,
      ),
      onPressed: press(),
    );
  }
}

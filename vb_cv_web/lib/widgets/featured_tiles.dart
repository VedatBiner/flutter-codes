/// <----- featured_tiles.dart ----->
library;

import 'package:flutter/material.dart';

import '../widgets/responsive.dart';

class FeaturedTiles extends StatelessWidget {
  FeaturedTiles({
    super.key,
    required this.screenSize,
  });

  final Size screenSize;

  final List<String> assets = [
    'assets/images/sysadmin.jpg',
    'assets/images/flutter_developer.jpg',
    'assets/images/python_developer.jpg',
    'assets/images/web_developer.jpg',
  ];

  final List<String> title = [
    'Sistem Yöneticisi',
    'Mobil Uygulama Geliştirici',
    'Python Uygulama Geliştirici',
    'Web Tasarımcı'
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget.isSmallScreen(context)
        ? Padding(
      padding: EdgeInsets.only(top: screenSize.height / 50),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int pageIndex = 0; pageIndex < assets.length; pageIndex++)
              Column(
                children: [
                  SizedBox(
                    height: screenSize.width / 2.5,
                    width: screenSize.width / 1.5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Image.asset(
                        assets[pageIndex],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: screenSize.height / 70,
                    ),
                    child: Text(
                      title[pageIndex],
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context)
                            .primaryTextTheme
                            .titleMedium!
                            .color,
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize.height / 50),
                ],
              ),
          ],
        ),
      ),
    )
        : Padding(
      padding: EdgeInsets.only(
        top: screenSize.height * 0.06,
        left: screenSize.width / 15,
        right: screenSize.width / 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (int pageIndex = 0; pageIndex < assets.length; pageIndex++)
            Column(
              children: [
                SizedBox(
                  height: screenSize.width / 6,
                  width: screenSize.width / 3.8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.asset(
                      assets[pageIndex],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: screenSize.height / 70,
                  ),
                  child: Text(
                    title[pageIndex],
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context)
                          .primaryTextTheme
                          .titleMedium!
                          .color,
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height / 50),
              ],
            ),
        ],
      ),
    );
  }
}

/// <----- home_page.dart ----->
/// Ana sayfamız burası

library;

import 'package:flutter/material.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';

import '../widgets/bottom_bar.dart';
import '../widgets/carousel.dart';
import '../widgets/destination_heading.dart';
import '../widgets/explore_drawer.dart';
import '../widgets/main_work_title.dart';
import '../widgets/featured_tiles.dart';
import '../widgets/floating_quick_access_bar.dart';
import '../widgets/responsive.dart';
import '../widgets/top_bar_contents.dart';

class HomePage extends StatefulWidget {
  static const String route = '/';

  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollController;
  double _scrollPosition = 0;
  double _opacity = 0;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    _opacity = _scrollPosition < screenSize.height * 0.40
        ? _scrollPosition / (screenSize.height * 0.40)
        : 1;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: ResponsiveWidget.isSmallScreen(context)
          ? AppBar(
              backgroundColor: Theme.of(context)
                  .bottomAppBarTheme
                  .color
                  ?.withOpacity(_opacity),
              elevation: 0,
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.brightness_6),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  color: Colors.white,
                  onPressed: () {
                    EasyDynamicTheme.of(context).changeTheme();
                  },
                ),
              ],
              title: Text(
                'Vedat Biner',
                style: TextStyle(
                  color: Colors.blueGrey[100],
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  letterSpacing: 3,
                ),
              ),
            )
          : PreferredSize(
              preferredSize: Size(screenSize.width, 1000),
              child: TopBarContents(_opacity),
            ),
      drawer: const ExploreDrawer(),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: screenSize.height * 0.45,
                  width: screenSize.width,
                  child: Image.asset(
                    'assets/images/cover.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  children: [
                    FloatingQuickAccessBar(screenSize: screenSize),
                    Column(
                      children: [
                        FeaturedHeading(
                          screenSize: screenSize,
                        ),
                        FeaturedTiles(screenSize: screenSize)
                      ],
                    ),
                  ],
                )
              ],
            ),
            DestinationHeading(screenSize: screenSize),
            const DestinationCarousel(),
            SizedBox(height: screenSize.height / 10),
            const BottomBar(),
          ],
        ),
      ),
    );
  }
}

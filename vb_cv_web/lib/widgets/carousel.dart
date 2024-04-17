/// <----- carousel.dart ----->
library;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../widgets/responsive.dart';

class DestinationCarousel extends StatefulWidget {
  const DestinationCarousel({super.key});

  @override
  State<StatefulWidget> createState() => _DestinationCarouselState();
}

class _DestinationCarouselState extends State<DestinationCarousel> {
  final String imagePath = 'assets/images/';

  final CarouselController _controller = CarouselController();

  final _isHovering = [false, false, false, false, false, false, false];
  final _isSelected = [true, false, false, false, false, false, false];

  int _current = 0;

  final images = [
    'assets/images/experience_1.jpg',
    'assets/images/experience_2.jpg',
    'assets/images/experience_3.jpg',
    'assets/images/experience_1.jpg',
    'assets/images/experience_2.jpg',
    'assets/images/experience_3.jpg',
  ];

  final places = [
    'Aselsan A.Ş.',
    'TEPUM Ltd. Şti.',
    'Protek A.Ş.',
    'Hava Kuvvetleri Komutanlığı',
    'Data Sistem ve Teknoloji',
    'Girişim Bilgisayar Eğitim Merkezi',
  ];

  final locations = [
    'Ankara, 01/1999 - 12/2020',
    'Ankara, 01/1993 - 11/1998',
    'Ankara, 08/1991 - 11/1992',
    'Ankara, 07/1990 - 07/1991',
    'Ankara, 02/1988 - 03/1990',
    'Ankara, 10/1987 - 02/1988',
  ];

  List<Widget> generateImageTiles(screenSize) => images
      .map(
        (element) => ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Image.asset(
            element,
            fit: BoxFit.cover,
          ),
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var imageSliders = generateImageTiles(screenSize);

    return Stack(
      children: [
        CarouselSlider(
          items: imageSliders,
          options: CarouselOptions(
              scrollPhysics: ResponsiveWidget.isSmallScreen(context)
                  ? const PageScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              enlargeCenterPage: true,
              aspectRatio: 18 / 8,
              autoPlay: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                  for (int i = 0; i < imageSliders.length; i++) {
                    if (i == index) {
                      _isSelected[i] = true;
                    } else {
                      _isSelected[i] = false;
                    }
                  }
                });
              }),
          carouselController: _controller,
        ),
        AspectRatio(
          aspectRatio: 18 / 8,
          child: Column(
            children: [
              Opacity(
                opacity: 0.7,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.68,
                    height: MediaQuery.of(context).size.height * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        places[_current],
                        style: TextStyle(
                          letterSpacing: 6,
                          fontFamily: 'Electrolize',
                          fontSize: screenSize.width / 35,
                          // color: Theme.of(context).primaryColor
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Text(locations[_current]),
            ],
          ),
        ),
        ResponsiveWidget.isSmallScreen(context)
            ? Container()
            : AspectRatio(
                aspectRatio: 17 / 8,
                child: Center(
                  heightFactor: 1,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: screenSize.width / 8,
                        right: screenSize.width / 8,
                      ),
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: screenSize.height / 50,
                            bottom: screenSize.height / 50,
                          ),

                          /// Alt menu bar
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (int i = 0; i < places.length; i++)
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      onHover: (value) {
                                        setState(() {
                                          value
                                              ? _isHovering[i] = true
                                              : _isHovering[i] = false;
                                        });
                                      },
                                      onTap: () {
                                        _controller.animateToPage(i);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: screenSize.height / 80,
                                            bottom: screenSize.height / 90),
                                        child: Text(
                                          /// iş yeri başlıkları burada
                                          places[i],
                                          style: TextStyle(
                                            color: _isHovering[i]
                                                ? Theme.of(context)
                                                    .primaryTextTheme
                                                    .labelLarge!
                                                    .decorationColor
                                                : Theme.of(context)
                                                    .primaryTextTheme
                                                    .labelLarge!
                                                    .color,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      visible: _isSelected[i],
                                      child: AnimatedOpacity(
                                        duration:
                                            const Duration(milliseconds: 600),
                                        opacity: _isSelected[i] ? 1 : 0,
                                        child: Container(
                                          height: 5,

                                          /// alt çizgi kırmızı olsun
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          width: screenSize.width / 10,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}

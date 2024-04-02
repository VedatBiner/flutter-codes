/// <----- bottom_bar.dart ----->
library;

import 'package:flutter/material.dart';

import '../widgets/responsive.dart';
import '../widgets/info_text.dart';
import '../widgets/bottom_bar_column.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      // color: Theme.of(context).bottomAppBarColor,
      color: Theme.of(context).bottomAppBarTheme.color,
      child: ResponsiveWidget.isSmallScreen(context)
          ? Column(
        children: [
          const Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BottomBarColumn(
                heading: 'HAKKIMDA',
                s1: 'İletişim',
                s2: 'Hakkımda',
                s3: 'Careers',
              ),
              // BottomBarColumn(
              //   heading: 'HELP',
              //   s1: 'Payment',
              //   s2: 'Cancellation',
              //   s3: 'FAQ',
              // ),
              BottomBarColumn(
                heading: 'SOSYAL MEDYA',
                s1: 'Twitter',
                s2: 'Facebook',
                s3: 'YouTube',
              ),
            ],
          ),
          Container(
            color: Colors.blueGrey,
            width: double.maxFinite,
            height: 1,
          ),
          const SizedBox(height: 20),
          const InfoText(
            type: 'Email',
            text: 'vbiner@gmail.com',
          ),
          const SizedBox(height: 5),
          const InfoText(
            type: 'Address',
            text: 'Ankara - TÜRKİYE',
          ),
          const SizedBox(height: 20),
          Container(
            color: Colors.blueGrey,
            width: double.maxFinite,
            height: 1,
          ),
          const SizedBox(height: 20),
          Text(
            'Copyright © 2024 | Vedat Biner',
            style: TextStyle(
              color: Colors.blueGrey[300],
              fontSize: 14,
            ),
          ),
        ],
      )
          : Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const BottomBarColumn(
                heading: 'HAKKIMDA',
                s1: 'İletişim',
                s2: 'Hakkımda',
                s3: 'Careers',
              ),

              const BottomBarColumn(
                heading: 'SOSYAL MEDYA',
                s1: 'Twitter',
                s2: 'Facebook',
                s3: 'YouTube',
              ),
              Container(
                color: Colors.blueGrey,
                width: 2,
                height: 150,
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoText(
                    type: 'Email',
                    text: 'vbiner@gmail.com',
                  ),
                  SizedBox(height: 5),
                  InfoText(
                    type: 'Address',
                    text: 'Ankara - TURKİYE',
                  )
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.blueGrey,
              width: double.maxFinite,
              height: 1,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Copyright © 2024 | Vedat Biner',
            style: TextStyle(
              color: Colors.blueGrey[300],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
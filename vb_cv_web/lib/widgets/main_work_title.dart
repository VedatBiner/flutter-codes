/// <----- main_work_title.dart ----->
/// Ana çalışma konularım başlığı burada
library;
import 'package:flutter/material.dart';

import '../widgets/responsive.dart';

class FeaturedHeading extends StatelessWidget {
  const FeaturedHeading({
    super.key,
    required this.screenSize,
  });

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: screenSize.height * 0.06,
        left: screenSize.width / 15,
        right: screenSize.width / 15,
      ),
      child: ResponsiveWidget.isSmallScreen(context)
          ? const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(),
                Text(
                  'Ana çalışma konularım',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                // Text(
                //   'Unique wildlife tours & destinations',
                //   textAlign: TextAlign.end,
                //   style: Theme.of(context).primaryTextTheme.titleMedium,
                // ),
                SizedBox(height: 10),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Ana çalışma konularım',
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    // ben ekledim
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                // Expanded(
                //   child: Text(
                //     'Unique wildlife tours & destinations',
                //     textAlign: TextAlign.end,
                //     style: Theme.of(context).primaryTextTheme.titleMedium,
                //   ),
                // ),
              ],
            ),
    );
  }
}

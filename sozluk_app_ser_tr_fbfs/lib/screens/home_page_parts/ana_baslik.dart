/// <----- ana_baslik.dart ----->

import 'package:flutter/material.dart';

import '../../screens/home_page_parts/showflag_widget.dart';

class AnaBaslik extends StatelessWidget {
  const AnaBaslik({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShowFlagWidget(
              code: 'RS',
              text: 'Sırpça',
              radius: 8,
            ),
            ShowFlagWidget(
              code: 'TR',
              text: 'Türkçe',
              radius: 8,
            ),
            Expanded(
              flex: 1,
              child: SizedBox(width: 20),
            ),
          ],
        ),
      ),
    );
  }
}

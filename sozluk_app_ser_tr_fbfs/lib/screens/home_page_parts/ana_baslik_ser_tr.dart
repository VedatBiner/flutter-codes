/// <----- ana_baslik.dart ----->
library;

import 'package:flutter/material.dart';
import 'package:sozluk_app_ser_tr_fbfs/constants/app_constants/constants.dart';

import '../../screens/home_page_parts/showflag_widget.dart';

class AnaBaslik extends StatelessWidget {
  const AnaBaslik({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const ShowFlagWidget(
              code: 'RS',
              text: 'Sırpça',
              radius: 8,
            ),
            const ShowFlagWidget(
              code: 'TR',
              text: 'Türkçe',
              radius: 8,
            ),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.swap_horizontal_circle_rounded,
                  color: menuColor,
                )),
            // const Expanded(
            //   flex: 1,
            //   child: SizedBox(width: 20),
            // ),
          ],
        ),
      ),
    );
  }
}

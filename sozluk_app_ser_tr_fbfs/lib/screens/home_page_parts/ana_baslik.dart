import 'package:flutter/material.dart';

import '../../widgets/flags_widget.dart';

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
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FlagWidget(
                    countryCode: 'RS',
                    radius: 8,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Sırpça',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  FlagWidget(
                    countryCode: 'TR',
                    radius: 8,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Türkçe',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
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

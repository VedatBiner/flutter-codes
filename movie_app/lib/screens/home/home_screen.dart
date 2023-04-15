import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: const Body(),
    );
  }

  // AppBar oluşturan metodumuz
  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        padding: const EdgeInsets.only(left: kDefaultPadding),
          onPressed: (){},
          icon: SvgPicture.asset("assets/icons/menu.svg"),
      ),
      actions: [
        IconButton(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            onPressed: (){},
            icon: SvgPicture.asset("assets/icons/search.svg"),
        )
      ],
    );
  }
}

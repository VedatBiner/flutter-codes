import 'package:flutter/material.dart';
import 'package:recipe_app/screens/profile/components/profile_menu_item.dart';
import 'package:recipe_app/size_config.dart';
import 'info.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Info(
            image: "assets/images/pic.png",
            name: "John doe",
            email: "johndoe@gmail.com",
          ),
          SizedBox(height: SizeConfig.defaultSize! * 2),
          ProfileMenuItem(
            iconSrc: "assets/icons/bookmark_fill.svg",
            title: "Saved Recipes",
            press: () {},
          ),
          ProfileMenuItem(
            iconSrc: "assets/icons/chef_color.svg",
            title: "Super Plan",
            press: () {},
          ),
          ProfileMenuItem(
            iconSrc: "assets/icons/language.svg",
            title: "Change Language",
            press: () {},
          ),
          ProfileMenuItem(
            iconSrc: "assets/icons/info.svg",
            title: "Help",
            press: () {},
          ),
        ],
      ),
    );
  }
}


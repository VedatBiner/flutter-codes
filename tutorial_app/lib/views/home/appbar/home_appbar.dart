/// <----- home_appbar.dart ----->
library;

import 'package:flutter/material.dart';
import 'package:tutorial_app/core/extension/context_extension.dart';

import '../../../constant/app_const.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "${context.language ? AppConst.home.themeText.tr : AppConst.home.themeText.en}",
      ),
      /// Bir önceki ekrana dönüşü engellemek için adım 2.
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

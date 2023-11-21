/// <----- home_view.dart ----->
library;

import 'package:flutter/material.dart';

import '../../config/route/app_routes.dart';
import '../../constant/app_const.dart';
import '../../core/extension/context_extension.dart';

/// parts field
part "appbar/home_appbar.dart";
part "body/home_body.dart";
part "child/about/home_about_view.dart";
part "child/detail/home_detail_view.dart";
part "drawer/home_drawer.dart";

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    /// Bir önceki ekrana dönüşü engellemek için adım 1.
    return PopScope(
      child: Scaffold(
        key: AppConst.home.scaffoldKey,
        drawer: size.width < 800 ? const _HomeDrawer() : null,
        appBar: _HomeAppBar(),
        body: const _HomeBody(),
      ),
    );
  }
}

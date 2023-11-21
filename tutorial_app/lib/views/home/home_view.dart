/// <----- home_view.dart ----->
library;

import 'package:flutter/material.dart';

import '../../config/route/app_routes.dart';
import '../../constant/app_const.dart';
import '../../core/extension/context_extension.dart';

/// parts field
part "body/home_body.dart";
part "appbar/home_appbar.dart";

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {

    /// Bir önceki ekrana dönüşü engellemek için adım 1.
    return PopScope(
      child: Scaffold(
        body: const _HomeBody(),
        appBar: _HomeAppBar(),
      ),
    );
  }
}

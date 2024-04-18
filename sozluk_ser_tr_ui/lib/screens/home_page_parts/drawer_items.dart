/// <----- drawer_items.dart ----->
/// Drawer seçeneklerini gösteren metot
library;

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants/constants.dart';
import '../../services/auth_services.dart';
import '../../services/theme_provider.dart';
import '../../services/app_routes.dart';

Drawer buildDrawer(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context);

  /// login olan kullanıcı bilgisini al
  String currentUserEmail =
      FirebaseAuth.instance.currentUser?.email ?? 'vbiner@gmail.com';


  return Drawer(
    shadowColor: Colors.lightBlue,
    backgroundColor: drawerColor,
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: drawerColor,
          ),
          child: Text(
            drawerTitle,
            style: baslikTextDrawer,
          ),
        ),
        for (var item in drawerItems)
          buildListTile(context, item["title"], (BuildContext context) {
            final pageRoute = AppRoute.routes[item["page"]];
            return pageRoute != null ? pageRoute(context) : Container();
          }),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  tooltip: "Dark/Light Theme",
                  color: menuColor,
                  onPressed: () {
                    final provider =
                        Provider.of<ThemeProvider>(context, listen: false);
                    provider.toggleTheme(!provider.isDarkMode);
                  },
                  icon: Icon(
                    themeProvider.isDarkMode
                        ? Icons.wb_sunny
                        : Icons.brightness_3,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: IconButton(
                  tooltip: "Settings",
                  color: menuColor,
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    /// Settings sayfasına gidilir.
                    Navigator.pushNamed(
                      context,
                      AppRoute.settings,
                    );
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: IconButton(
                  tooltip: "Sign Out",
                  color: menuColor,
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    auth.signOut().whenComplete(
                      () async {
                        /// kullanıcıya çıkış yaptırır ve
                        /// giriş sayfasına yönlendirir
                        await Navigator.pushNamed(
                          context,
                          AppRoute.login,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const Divider(),
        FutureBuilder<String?>(
          future: getVersion(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kullanıcı : $currentUserEmail",
                      style: TextStyle(color: menuColor),
                    ),
                    Text(
                      "v${snapshot.data}\nvbiner@gmail.com",
                      style: TextStyle(color: menuColor),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ],
    ),
  );
}

ListTile buildListTile(
  BuildContext context,
  String text,
  Widget Function(BuildContext) pageRouteGetter,
) {
  return ListTile(
    textColor: menuColor,
    title: Text(text),
    onTap: () {
      Navigator.pop(context); // Drawer'ı kapat
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => pageRouteGetter(context),
        ),
      );
    },
  );
}

Future<String?> getVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

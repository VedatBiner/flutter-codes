/// <----- home_appbar.dart ----->

part of "../home_view.dart";

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = AppConst.listener.themeNotifier;
    return AppBar(
      title: Text(
        "${context.language ? AppConst.home.themeText.tr : AppConst.home.themeText.en}",
      ),

      /// Bir önceki ekrana dönüşü engellemek için adım 2.
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: () {
            AppConst.listener.language.changeLang();
          },
          icon: const Icon(Icons.language),
        ),
        const SizedBox(width: 16),
        IconButton(
          onPressed: () => AppConst.listener.themeNotifier.changeTheme(),
          icon: Icon(
            themeNotifier.isDarkMode ? Icons.wb_sunny : Icons.brightness_3,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => Navigator.pushNamed(context, AppRoute.splash),
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}











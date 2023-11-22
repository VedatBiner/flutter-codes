/// <----- home_appbar.dart ----->

part of "../home_view.dart";

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  _HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return AppBar(
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          onPressed: (){
            if (!AppConst.home.scaffoldKey.currentState!.isDrawerOpen){
              AppConst.home.scaffoldKey.currentState!.openDrawer();
              /// 42
            }
          },
          icon: const Icon(
            Icons.menu,
            size: 48,
          ),
        ),
      ),
      title: size.width > 800 ? const _AppTitle() : null,

      /// Bir önceki ekrana dönüşü engellemek için adım 2.
      automaticallyImplyLeading: false,
      actions: appBarActions(context),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
  final themeNotifier = AppConst.listener.themeNotifier;

  List<Widget> appBarActions(BuildContext context) => [
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
      ];
}

class _AppTitle extends StatelessWidget {
  const _AppTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 450,
      height: 60,
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return ElevatedButton(
            onPressed: () => AppConst.home.pageController.value.animateToPage(
              index,
              duration: const Duration(milliseconds: 100),
              curve: Curves.elasticInOut,
            ),
            child: Text("Page : $index"),
          );
        },
        shrinkWrap: true,
      ),
    );
  }
}










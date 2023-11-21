/// <----- home_body.dart ----->

part of "../home_view.dart";

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: AppConst.home.pageController,
        builder: (context, controller, child) {
          return PageView(
            controller: controller,
            children: [
              bodyChild(context),
              const _HomeAboutView(),
              const _HomeDetailView(),
            ],
          );
        });
  }
}

Center bodyChild(BuildContext context) {
  return Center(
    child: Column(
      children: [
        const Icon(
          Icons.home,
          size: 256,
        ),
        const SizedBox(height: 50),
        ElevatedButton(
          onPressed: () => AppConst.home.pageController.value.nextPage(
            duration: const Duration(
              milliseconds: 200,
            ),
            curve: Curves.bounceInOut,
          ),
          child: const Text("Next Page"),
        ),
        Container(
          color: context.theme.cardColor,
          height: 200,
          width: 200,
        ),
        const SizedBox(height: 50),
        Text(
          "${context.language ? AppConst.home.welcome.tr : AppConst.home.welcome.en}",
        ),
      ],
    ),
  );
}

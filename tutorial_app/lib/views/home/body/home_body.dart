/// <----- home_body.dart ----->

part of "../home_view.dart";

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        bodyChild(context),
        const HomeAboutView(),
        const HomeDetailView(),
      ],
    );
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

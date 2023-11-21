/// <----- home_about_view.dart ----->

part of "../../home_view.dart";

class _HomeAboutView extends StatelessWidget {
  const _HomeAboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Home About View",
          style: context.theme.textTheme.headlineLarge,
        ),
      ],
    );
  }
}

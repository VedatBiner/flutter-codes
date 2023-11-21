/// <----- home_about_view.dart ----->

part of "../../home_view.dart";

class HomeAboutView extends StatelessWidget {
  const HomeAboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Home About View",
          style: context.theme.textTheme.displaySmall,
        ),
      ],
    );
  }
}

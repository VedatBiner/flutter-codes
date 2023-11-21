/// <----- home_detail_view.dart ----->

part of "../../home_view.dart";

class _HomeDetailView extends StatelessWidget {
  const _HomeDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Home Detail View",
          style: context.theme.textTheme.headlineLarge,
        ),
      ],
    );
  }
}

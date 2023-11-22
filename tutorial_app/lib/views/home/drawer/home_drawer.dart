/// <----- home_drawer.dart ----->

part of "../../home/home_view.dart";

class _HomeDrawer extends StatelessWidget {
  const _HomeDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          SizedBox(
            height: 300,
            child: ListView.separated(
              itemBuilder: (context, index) {
                return ElevatedButton(
                  onPressed: () {
                    AppConst.home.pageController.value.jumpToPage(index);
                  },
                  child: Text("Page : $index"),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemCount: 3,
            ),
          ),
        ],
      ),
    );
  }
}

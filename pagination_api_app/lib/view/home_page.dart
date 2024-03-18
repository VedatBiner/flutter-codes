/// <----- home_page.dart ----->

library;

import 'package:flutter/material.dart';

import '../repository/page_status.dart';
import '../repository/user_repo.dart';
import '../view/widget/list_item.dart';

PageStorageKey pageStorageKey = const PageStorageKey("pageStorageKey");
final PageStorageBucket pageStorageBucket = PageStorageBucket();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserRepository userRepo = UserRepository();

  /// scroll durumunu izlemek için bir controller
  ScrollController? scrollController;

  /// uygulama başlayınca verileri çekiyoruz
  @override
  void initState() {
    createScrollController();
    userRepo.getInitialUsers();
    super.initState();
  }

  void createScrollController() {
    scrollController = ScrollController();

    /// scroll controller dinleyelim
    scrollController?.addListener(loadMoreUsers);
  }

  Future<void> loadMoreUsers() async {
    ///  sayfanın sonunu kontrol et
    if (scrollController!.position.pixels >
            scrollController!.position.maxScrollExtent &&
        userRepo.pageStatus.value != PageStatus.newPageLoading) {
      await userRepo.loadMoreUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: body(),
      ),
    );
  }

  Widget body() {
    return ValueListenableBuilder<PageStatus>(
      /// pageStatus dinlenecek
      valueListenable: userRepo.pageStatus,
      builder: (context, PageStatus pageStatus, _) {
        switch (pageStatus) {
          case PageStatus.idle:
            return idleWidget();
          case PageStatus.firstPageLoading:
            return firstPageLoadingWidget();
          case PageStatus.firstPageError:
            return firstPageErrorWidget();
          case PageStatus.firstPageNoItemsFound:
            return firstPageNoItemsFoundWidget();
          case PageStatus.newPageLoaded:
          case PageStatus.firstPageLoaded:
            return firstPageLoadedWidget();
          case PageStatus.newPageLoading:
            return newPageLoadingWidget();
          case PageStatus.newPageError:
            return newPageErrorWidget();
          case PageStatus.newPageNoItemsFound:
            return newPageNoItemsFoundWidget();
        }
      },
    );
  }

  Widget listViewBuilder() {
    if (scrollController?.hasClients == true) {
      scrollController!.jumpTo(scrollController!.position.maxScrollExtent);
    }
    return PageStorage(
      key: pageStorageKey,
      bucket: pageStorageBucket,
      child: ListView.builder(
          controller: scrollController,
          itemCount: userRepo.users.length,
          itemBuilder: (context, index) {
            var currentUser = userRepo.users[index];
            return ListItem(currentUser, index);
          }),
    );
  }

  /// herhangi bir işlemin başlamadığı kısım
  Widget idleWidget() => const SizedBox();

  /// ilk sayfa yükleniyor
  Widget firstPageLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  /// ilk sayfa boş ise
  Widget firstPageNoItemsFoundWidget() {
    return const Center(
      child: Text("İçerik bulunmadı"),
    );
  }

  /// ilk sayfa hatalı ise
  Widget firstPageErrorWidget() {
    return const Center(
      child: Text("Hata oluştu"),
    );
  }

  /// ilk sayfa başarılı yüklendi
  Widget firstPageLoadedWidget() {
    return listViewBuilder();
  }

  /// yeni sayfa yükleniyor
  Widget newPageLoadingWidget() {
    return Stack(
      children: [
        listViewBuilder(),
        bottomIndicator(),
      ],
    );
  }

  /// hata oluştu
  Widget newPageErrorWidget() {
    return Column(
      children: [
        Expanded(
          child: listViewBuilder(),
        ),
        bottomMessage("Yeni sayfa bulunamadı")
      ],
    );
  }

  /// yeni sayfalarda içerik yoksa
  Widget newPageNoItemsFoundWidget() {
    return Column(
      children: [
        Expanded(
          child: listViewBuilder(),
        ),
        bottomMessage("İlave içerik bulunamadı")
      ],
    );
  }

  /// sayfanın yükleniyor olduğunu göstermek için
  Widget bottomIndicator() {
    return bottomWidget(
      child: const Padding(
        padding: EdgeInsets.all(18.0),
        child: LinearProgressIndicator(
          color: Colors.black,
        ),
      ),
    );
  }

  /// işlemin durumu ile ilgili mesaj
  Widget bottomMessage(String message) {
    return bottomWidget(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(message),
      ),
    );
  }

  Widget bottomWidget({required Widget child}) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  @override
  void dispose() {
    scrollController?.dispose();
    super.dispose();
  }
}






















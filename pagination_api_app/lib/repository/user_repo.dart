/// <----- user_repo.dart ----->
library;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../repository/page_status.dart';
import '../model/user_model.dart';

class UserRepository {
  List<User> users = [];
  int perPage = 10;
  int pageKey = 1;
  ValueNotifier<PageStatus> pageStatus = ValueNotifier<PageStatus>(
    PageStatus.idle,
  );

  Future getInitialUsers() async {
    /// yükleniyor göstergesi
    pageStatus.value = PageStatus.firstPageLoading;
    try {
      /// servisten listeyi çekiyoruz.
      /// Birinci sayfadan başlıyoruz
      await fetchUsers(1);
      if (users.isEmpty) {
        /// ilk sayfada veri bulunamadı
        pageStatus.value = PageStatus.firstPageNoItemsFound;
      } else {
        /// ilk sayfada veri var
        pageStatus.value = PageStatus.firstPageLoaded;
      }
    } catch (e) {
      /// hata olması durumu
      pageStatus.value = PageStatus.firstPageError;
    }
  }

  /// diğer sayfalar
  Future loadMoreUsers() async {
    /// yükleniyor göstergesi
    pageStatus.value = PageStatus.newPageLoading;
    pageKey++;
    try {
      /// servisten listeyi çekiyoruz.
      /// Birinci sayfadan başlıyoruz
      int currentUsersCount = users.length;
      await fetchUsers(pageKey);

      if (currentUsersCount == users.length) {
        /// ilk sayfada veri bulunamadı
        pageStatus.value = PageStatus.newPageNoItemsFound;
      } else {
        /// yeni sayfa yüklendi
        pageStatus.value = PageStatus.newPageLoaded;
      }
    } catch (e) {
      /// hata olması durumu
      pageStatus.value = PageStatus.newPageError;
    }
  }

  Future<void> fetchUsers(int pageKey) async {
    String apiUrl = "https://randomuser.me/api/?results=$perPage&page=$pageKey";
    final response = await http.get(Uri.parse(apiUrl));

    try {
      for (var map in jsonDecode(response.body)["results"]) {
        users.add(User.fromMap(map));
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}


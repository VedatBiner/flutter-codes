import 'package:flutter/material.dart';
import 'package:minimalist_state_man/post.dart';

class ListViewState {
  /*
  ValueNotifier<List<Post>> postsNotifier = ValueNotifier<List<Post>>([
    Post(
      userId: 1,
      id: 1,
      title:
          "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
      body:
          "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto",
    ),
    Post(
      userId: 1,
      id: 2,
      title: "qui est esse",
      body:
          "est rerum tempore vitae\nsequi sint nihil reprehenderit dolor beatae ea dolores neque\nfugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis\nqui aperiam non debitis possimus qui neque nisi nulla",
    ),
    Post(
      userId: 1,
      id: 3,
      title: "ea molestias quasi exercitationem repellat qui ipsa sit aut",
      body:
          "et iusto sed quo iure\nvoluptatem occaecati omnis eligendi aut ad\nvoluptatem doloribus vel accusantium quis pariatur\nmolestiae porro eius odio et labore et velit aut",
    ),
    Post(
      userId: 1,
      id: 4,
      title: "eum et est occaecati",
      body:
          "ullam et saepe reiciendis voluptatem adipisci\nsit amet autem assumenda provident rerum culpa\nquis hic commodi nesciunt rem tenetur doloremque ipsam iure\nquis sunt voluptatem rerum illo velit",
    ),
    Post(
      userId: 1,
      id: 5,
      title: "nesciunt quas odio",
      body:
          "repudiandae veniam quaerat sunt sed\nalias aut fugiat sit autem sed est\nvoluptatem omnis possimus esse voluptatibus quis\nest aut tenetur dolor neque",
    ),
    Post(
      userId: 1,
      id: 6,
      title: "dolorem eum magni eos aperiam quia",
      body:
          "ut aspernatur corporis harum nihil quis provident sequi\nmollitia nobis aliquid molestiae\nperspiciatis et ea nemo ab reprehenderit accusantium quas\nvoluptate dolores velit et doloremque molestiae",
    ),
    Post(
      userId: 1,
      id: 7,
      title: "magnam facilis autem",
      body:
          "dolore placeat quibusdam ea quo vitae\nmagni quis enim qui quis quo nemo aut saepe\nquidem repellat excepturi ut quia\nsunt ut sequi eos ea sed quas",
    ),
    Post(
      userId: 1,
      id: 8,
      title: "dolorem dolore est ipsam",
      body:
          "dignissimos aperiam dolorem qui eum\nfacilis quibusdam animi sint suscipit qui sint possimus cum\nquaerat magni maiores excepturi\nipsam ut commodi dolor voluptatum modi aut vitae",
    ),
  ]);

  // tıklanan postu sil
  void postRemoveTapped(Post postToRemove){
    postsNotifier.value.remove(postToRemove);
    // liste güncelleme 1. yöntem
    // postsNotifier.value = [...postsNotifier.value];
    // liste güncelleme 2. yöntem - daha kullanışlı
    postsNotifier.value = List<Post>.from(postsNotifier.value);
  }

  // yeni post ekle
  void addPostTapped(Post postToAdd){
    postsNotifier.value.add(postToAdd);
    postsNotifier.value = List<Post>.from(postsNotifier.value);
  }

   */

  MyListViewNotifier postsNotifier = MyListViewNotifier([
    Post(
      userId: 1,
      id: 1,
      title:
      "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
      body:
      "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto",
    ),
    Post(
      userId: 1,
      id: 2,
      title: "qui est esse",
      body:
      "est rerum tempore vitae\nsequi sint nihil reprehenderit dolor beatae ea dolores neque\nfugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis\nqui aperiam non debitis possimus qui neque nisi nulla",
    ),
    Post(
      userId: 1,
      id: 3,
      title: "ea molestias quasi exercitationem repellat qui ipsa sit aut",
      body:
      "et iusto sed quo iure\nvoluptatem occaecati omnis eligendi aut ad\nvoluptatem doloribus vel accusantium quis pariatur\nmolestiae porro eius odio et labore et velit aut",
    ),
    Post(
      userId: 1,
      id: 4,
      title: "eum et est occaecati",
      body:
      "ullam et saepe reiciendis voluptatem adipisci\nsit amet autem assumenda provident rerum culpa\nquis hic commodi nesciunt rem tenetur doloremque ipsam iure\nquis sunt voluptatem rerum illo velit",
    ),
    Post(
      userId: 1,
      id: 5,
      title: "nesciunt quas odio",
      body:
      "repudiandae veniam quaerat sunt sed\nalias aut fugiat sit autem sed est\nvoluptatem omnis possimus esse voluptatibus quis\nest aut tenetur dolor neque",
    ),
    Post(
      userId: 1,
      id: 6,
      title: "dolorem eum magni eos aperiam quia",
      body:
      "ut aspernatur corporis harum nihil quis provident sequi\nmollitia nobis aliquid molestiae\nperspiciatis et ea nemo ab reprehenderit accusantium quas\nvoluptate dolores velit et doloremque molestiae",
    ),
    Post(
      userId: 1,
      id: 7,
      title: "magnam facilis autem",
      body:
      "dolore placeat quibusdam ea quo vitae\nmagni quis enim qui quis quo nemo aut saepe\nquidem repellat excepturi ut quia\nsunt ut sequi eos ea sed quas",
    ),
    Post(
      userId: 1,
      id: 8,
      title: "dolorem dolore est ipsam",
      body:
      "dignissimos aperiam dolorem qui eum\nfacilis quibusdam animi sint suscipit qui sint possimus cum\nquaerat magni maiores excepturi\nipsam ut commodi dolor voluptatum modi aut vitae",
    ),
  ]);
}

class MyListViewNotifier extends ValueNotifier<List<Post>> {
  MyListViewNotifier(super.value);

  // tıklanan postu sil
  void postRemoveTapped(Post postToRemove) {
    value.remove(postToRemove);
    notifyListeners();
  }

  // yeni post ekle
  void addPostTapped(Post postToAdd) {
    value.add(postToAdd);
    notifyListeners();
  }
}














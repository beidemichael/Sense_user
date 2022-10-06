class Category {
  final int id;
  final String cat;

  Category({
    required this.id,
    required this.cat,
  });
}

class UserAuth {
  final String uid;
  UserAuth({required this.uid});
}

class UserInformation {
  String displayName;
  String email;
  bool isAnonymous;
  String phoneNumber;
  String photoURL;
  String uid;
  List category;

  UserInformation(
      {required this.displayName,
      required this.email,
      required this.isAnonymous,
      required this.phoneNumber,
      required this.photoURL,
      required this.uid,
      required this.category});
}

class News {
  String headline;
  String description;
  String image;
  List categories;
  List bookmarks;
  List readerList;
  bool active;
  var created;
  String author;
  String documentId;
  var snapshot;

  News({
    required this.active,
    required this.author,
    required this.categories,
    required this.created,
    required this.description,
    required this.headline,
    required this.image,
    required this.documentId,
    required this.bookmarks,
    required this.readerList,
    required this.snapshot,
  });
}

class NewsCategory {
  List category;
  NewsCategory({
    required this.category,
  });
}

typedef ValuesChanged<T, E> = void Function(T value, E valueTwo);
typedef void StringCallback(String val);
typedef void varCallback(var val);

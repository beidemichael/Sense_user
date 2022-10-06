import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/models.dart';

class DatabaseService {
  var userUid;
  var catForNews;
  var lastVisible;

  DatabaseService({this.userUid, this.catForNews, this.lastVisible});

  final CollectionReference newsCollection =
      FirebaseFirestore.instance.collection('News');
  final CollectionReference categoryCollection =
      FirebaseFirestore.instance.collection('Category');
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');
  List? userUidList;

  var lastVisibleNew;

  Timestamp get oneDay {
    final limit = DateTime.now().subtract(const Duration(days: 1));
    return Timestamp.fromDate(limit);
  }

  Timestamp get fourDays {
    final limit = DateTime.now().subtract(const Duration(days: 10));
    return Timestamp.fromDate(limit);
  }

  Timestamp get threeDays {
    final limit = DateTime.now().subtract(const Duration(days: 3));
    return Timestamp.fromDate(limit);
  }

  setNewsLastVisible() {
    lastVisibleNew = lastVisible;
    print('New Lastvisible set');
    return lastVisible;
  }

  Future publishNews(
    String headline,
    String description,
    String image,
    List categories,
  ) async {
    newsCollection
        .add({
          'Headline': headline,
          'Description': description,
          'Image': image,
          'Categories': categories,
          'Active': true,
          'Created': Timestamp.now(),
          'Author': 'Beidemichael'
        })
        .then((value) => print("News Added"))
        .catchError((error) => print("Failed to add News: $error"));
  }

  Future publishCategory() async {
    categoryCollection
        .add({})
        .then((value) => print("category Added"))
        .catchError((error) => print("Failed to add category: $error"));
  }

  Future newUser(User? user) async {
    userCollection
        .doc(user?.uid)
        .set({
          'displayName': user?.displayName,
          'email': user?.email,
          'isAnonymous': user?.isAnonymous,
          'phoneNumber': user?.phoneNumber,
          'photoURL': user?.photoURL,
          'uid': user?.uid
        })
        .then((value) => print("category Added"))
        .catchError((error) => print("Failed to add category: $error"));
  }

  List<UserInformation> _userInfoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserInformation(
        displayName: (doc.data() as dynamic)['displayName'] ?? '',
        email: (doc.data() as dynamic)['email'] ?? '',
        isAnonymous: (doc.data() as dynamic)['isAnonymous'] ?? false,
        phoneNumber: (doc.data() as dynamic)['phoneNumber'] ?? '',
        photoURL: (doc.data() as dynamic)['photoURL'] ?? '',
        category: (doc.data() as dynamic)['Categories'] ?? ['All'],
        uid: (doc.data() as dynamic)['uid'] ?? '',
      );
    }).toList();
  }

  //orders lounges stream
  Stream<List<UserInformation>> get userInfo {
    return userCollection
        .where('uid', isEqualTo: userUid)
        .snapshots()
        .map(_userInfoListFromSnapshot);
  }

  List<News> _newsListFromSnapshot(QuerySnapshot snapshot) {
    lastVisible = snapshot.docs[snapshot.docs.length - 1];
    // lastVisible = snapshot.docs.first;
    return snapshot.docs.map((doc) {
      return News(
        headline: (doc.data() as dynamic)['Headline'] ?? '',
        description: (doc.data() as dynamic)['Description'] ?? '',
        image: (doc.data() as dynamic)['Image'] ?? '',
        categories: (doc.data() as dynamic)['Categories'] ?? [],
        bookmarks: (doc.data() as dynamic)['bookMarkedBy'] ?? [],
        readerList: (doc.data() as dynamic)['readerList'] ?? [],
        active: (doc.data() as dynamic)['Active'] ?? false,
        created: (doc.data() as dynamic)['Created'] ?? '',
        author: (doc.data() as dynamic)['Author'] ?? '',
        documentId: doc.reference.id,
        snapshot: lastVisible,
      );
    }).toList();
  }

  //News
  Stream<List<News>> get news {
    if (lastVisible == null) {
      return newsCollection
          .where("Categories", arrayContainsAny: catForNews)
          .where("Active", isEqualTo: true)
          .where('Created', isGreaterThanOrEqualTo: threeDays)
          .orderBy('Created', descending: true)
          .limit(50)
          .snapshots()
          .handleError((onError) {
        print('errore in news read: '+onError.toString());
      }).map(_newsListFromSnapshot);
    } else {
      return newsCollection
          .where("Categories", arrayContainsAny: catForNews)
          .where("Active", isEqualTo: true)
          .where('Created', isGreaterThanOrEqualTo: threeDays)
          .orderBy('Created', descending: true)
          .startAfterDocument(lastVisible)
          .limit(50)
          .snapshots()
          .handleError((onError) {
        print('errore in news read: ' + onError.toString());
      }).map(_newsListFromSnapshot);
    }
  }

  Stream<List<News>> get bookmarkedNews {
    if (lastVisible == null) {
      return newsCollection
          .where('bookMarkedBy', arrayContains: userUid)
          .orderBy('Created', descending: true)
          .limit(50)
          .snapshots()
          .handleError((onError) {
        print(onError.toString());
      }).map(_newsListFromSnapshot);
    } else {
      return newsCollection
          .where('bookMarkedBy', arrayContains: userUid)
          .orderBy('Created', descending: true)
          .startAfterDocument(lastVisible)
          .limit(50)
          .snapshots()
          .handleError((onError) {
        print(onError.toString());
      }).map(_newsListFromSnapshot);
    }
  }

  Stream<List<News>> get unreadNews {
    if (lastVisible == null) {
      return newsCollection
          .where("Categories", arrayContainsAny: catForNews)
          // .where('readerList', arrayContainsAny: userUidList )
          .where('Created', isGreaterThanOrEqualTo: fourDays)
          .where('Created', isLessThanOrEqualTo: oneDay)
          .orderBy('Created', descending: true)
          .limit(60)
          .snapshots()
          .handleError((onError) {
        print(onError.toString());
      }).map(_newsListFromSnapshot);
    } else {
      return newsCollection
          .where("Categories", arrayContainsAny: catForNews)
          // .where('readerList', arrayContainsAny: userUidList )
          .where('Created', isGreaterThanOrEqualTo: fourDays)
          .where('Created', isLessThanOrEqualTo: oneDay)
          .orderBy('Created', descending: true)
          .startAfterDocument(lastVisible)
          .limit(60)
          .snapshots()
          .handleError((onError) {
        print(onError.toString());
      }).map(_newsListFromSnapshot);
    }
  }

  List<NewsCategory> listFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return NewsCategory(
        category: (doc.data() as dynamic)['Categories'] ?? [],
      );
    }).toList();
  }

  //orders lounges stream
  Stream<List<NewsCategory>> get newsCategory {
    return categoryCollection.snapshots().map(listFromSnapshot);
  }

  Future bookMark(
    String userUid,
    String documentId,
  ) async {
    newsCollection.doc(documentId).get().then((document) {
      userUidList = (document.data() as dynamic)['bookMarkedBy'] ?? [];
      userUidList?.add(userUid);
      newsCollection.doc(documentId).update({
        'bookMarkedBy': userUidList,
      });
    });
  }

  Future unBookMark(
    String userUid,
    String documentId,
  ) async {
    newsCollection.doc(documentId).get().then((document) {
      userUidList = (document.data() as dynamic)['bookMarkedBy'] ?? [];
      userUidList?.remove(userUid);
      newsCollection.doc(documentId).update({
        'bookMarkedBy': userUidList,
      });
    });
  }

  Future newsRead(
    String userUid,
    String documentId,
  ) async {
    newsCollection.doc(documentId).get().then((document) {
      userUidList = (document.data() as dynamic)['readerList'] ?? [];
      if (userUidList!.contains(userUid)) {
        return;
      } else {
        userUidList?.add(userUid);
        newsCollection.doc(documentId).update({
          'readerList': userUidList,
        });
      }
    });
  }

  Future userCategory(
    String userUid,
    List categories,
  ) async {
    userCollection.doc(userUid).update({
      'Categories': categories,
    });
  }
}

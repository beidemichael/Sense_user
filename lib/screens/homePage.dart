import 'package:flutter/material.dart';
import 'package:news_user/screens/newsPage/newsPage.dart';
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../service/database.dart';
import 'drawer/aboutUs.dart';
import 'drawer/drawer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  bool signedIn;
  String userUid;
  HomePage({required this.signedIn, required this.userUid});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? startDate;
  bool timeLoading = true;
  String page = 'home';
  var newsState;
  int tempBookmarkQty = 100;
  bool isHome = false;
  List userCategory = [];
  UserInformation userInfoForNull = UserInformation(
    displayName: '',
    email: '',
    isAnonymous: false,
    phoneNumber: '',
    photoURL: '',
    uid: '',
    category: [],
  );
  set string(String value) => setState(() => page = value);
  set news(var value) => setState(() => newsState = value);

  getBookmark(String uid) async {
    tempBookmarkQty = await DatabaseService(userUid: uid)
        .bookmarkedNews
        .length
        .catchError((error) => print("Failed to read length: $error"));
    print('bookmark int: ' + tempBookmarkQty.toString());
    return tempBookmarkQty;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTime();
    setState(() {
      timeLoading = false;
    });
  }

  getTime() async {
    startDate = await NTP.now();
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<List<UserInformation>>(context);

    if (userInfo != null) {
      if (userInfo.length != 0) {
        if (isHome == false) {
          DatabaseService().userCategory(widget.userUid, ['All']);
          isHome = true;
          //set category to all everytime the app opens.
        }

        userCategory = userInfo[0].category;
      }
    }

    
    return Scaffold(
      backgroundColor: Colors.grey[900],
      drawer: StreamProvider<List<NewsCategory>>.value(
          value: DatabaseService().newsCategory,
          initialData: [],
          child: DrawerContent(
            type: page,
            signedIn: widget.signedIn,
            callback: (val) => setState(() => page = val),
            varcallback: (val) {
              if (mounted) {
                setState(() => newsState = val);
              }
            },
          )),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Sense'),
          ],
        ),
      ),
      body: userInfo == null
          ? Center(
              child: SpinKitCircle(
              color: Colors.black,
              size: 50.0,
            ))
          : userInfo.length == 0
              ? Center(
                  child: SpinKitCircle(
                  color: Colors.black,
                  size: 50.0,
                ))
              : timeLoading == true
                  ? Center(
                      child: SpinKitCircle(
                      color: Colors.black,
                      size: 50.0,
                    ))
                  : page == 'home'
                      ? StreamProvider<List<News>>.value(
                          value: DatabaseService(
                                  catForNews: userCategory,
                                  lastVisible: newsState)
                              .news,
                          catchError: (_, __) => [],
                          initialData: [],
                          child: NewsPage(
                            userInfo: userInfo != null
                                ? userInfo[0]
                                : userInfoForNull,
                            type: 'home',
                            callback: (val) {
                              if (!mounted) {
                                setState(() => newsState = val);
                              }
                            },
                          ))
                      : page == 'bookmarks'
                          ? StreamProvider<List<News>>.value(
                              value: DatabaseService(
                                      userUid: userInfo[0].uid,
                                      lastVisible: newsState)
                                  .bookmarkedNews,
                              catchError: (_, __) => [],
                              initialData: [],
                              child: NewsPage(
                                  userInfo: userInfo != null
                                      ? userInfo[0]
                                      : userInfoForNull,
                                  type: 'bookmark',
                                  callback: (val) {
                                    if (mounted) {
                                      setState(() => newsState = val);
                                    }
                                  }))
                          : page == 'unread'
                              ? StreamProvider<List<News>>.value(
                                  value: DatabaseService(
                                          userUid: userInfo[0].uid,
                                          catForNews: userCategory,
                                          lastVisible: newsState)
                                      .unreadNews,
                                  catchError: (_, __) => [],
                                  initialData: [],
                                  child: NewsPage(
                                      userInfo: userInfo != null
                                          ? userInfo[0]
                                          : userInfoForNull,
                                      type: 'unread',
                                      callback: (val) {
                                        if (mounted) {
                                          setState(() => newsState = val);
                                        }
                                      }))
                              : page == 'aboutUs'
                                  ? AboutUs()
                                  : Container(),
    );
  }
}

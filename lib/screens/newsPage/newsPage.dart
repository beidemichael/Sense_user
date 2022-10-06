import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../service/database.dart';
import '../newsPageWidgets/text_container.dart';
import 'TextContainer.dart';

class NewsPage extends StatefulWidget {
  UserInformation userInfo;
  varCallback callback;
  String type;
  NewsPage({
    super.key,
    required this.userInfo,
    required this.callback,
    required this.type,
  });

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  PageController? pageController;
  ScrollController? activeScrollController;
  Drag? drag;
  int customIndex = 0;
  List<News>? news;

//These variables To detect if we are at the
//top or bottom of the list.
  bool? atTheTop;
  bool? atTheBottom;
  @override
  void initState() {
    super.initState();
    pageController = PageController()..addListener(_scrollListener);
    atTheTop = true;
    atTheBottom = false;
    if (news != null) news!.clear();
    // widget.callback("home");
  }

  @override
  void dispose() {
    pageController?.dispose();
    pageController!.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (pageController!.hasClients) {
      // print('Page view: ' + pageController!.position.extentAfter.toString());
      // if (pageController!.position.extentAfter < 500) {
      if (pageController!.position.pixels ==
          pageController!.position.maxScrollExtent) {
        setState(() {
          widget.callback(news!.last.snapshot);
        });
      }
    }
  }

  void handleDragStart(
      DragStartDetails details, ScrollController scrollController) {
    if (scrollController.hasClients) {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        atTheBottom = true;
      } else {
        atTheBottom = false;
      }

      if (scrollController.position.context.storageContext != null) {
        if (scrollController.position.pixels ==
            scrollController.position.minScrollExtent) {
          atTheTop = true;
        } else if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          atTheBottom = true;
        } else {
          atTheTop = false;
          atTheBottom = false;

          activeScrollController = scrollController;
          drag = activeScrollController?.position.drag(details, disposeDrag);
          return;
        }
      }
    }

    activeScrollController = pageController;
    drag = pageController?.position.drag(details, disposeDrag);
  }

  void handleDragUpdate(
      DragUpdateDetails details, ScrollController scrollController) {
    if (details.delta.dy > 0 && atTheTop!) {
      //Arrow direction is to the bottom.
      //Swiping up.

      activeScrollController = pageController;
      drag?.cancel();
      drag = pageController?.position.drag(
          DragStartDetails(
              globalPosition: details.globalPosition,
              localPosition: details.localPosition),
          disposeDrag);
    } else if (details.delta.dy < 0 && atTheBottom!) {
      //Arrow direction is to the top.
      //Swiping down.

      activeScrollController = pageController;
      drag?.cancel();
      drag = pageController?.position.drag(
          DragStartDetails(
            globalPosition: details.globalPosition,
            localPosition: details.localPosition,
          ),
          disposeDrag);
    } else {
      if (atTheTop! || atTheBottom!) {
        activeScrollController = scrollController;
        drag?.cancel();
        drag = scrollController.position.drag(
            DragStartDetails(
              globalPosition: details.globalPosition,
              localPosition: details.localPosition,
            ),
            disposeDrag);
      }
    }
    drag?.update(details);
  }

  void handleDragEnd(DragEndDetails details) {
    drag?.end(details);

    if (atTheTop!) {
      atTheTop = false;
    } else if (atTheBottom!) {
      atTheBottom = false;
    }
  }

  void handleDragCancel() {
    drag?.cancel();
  }

  void disposeDrag() {
    drag = null;
  }

  @override
  Widget build(BuildContext context) {
    final unfilteredNews = Provider.of<List<News>?>(context);

    if (unfilteredNews != null && widget.type == 'unread') {
      if (news != null) {
        setState(() {
          news!.clear();
        });
      }

      for (int i = 0; i < unfilteredNews.length; i++) {
        int j = 0;

        if (unfilteredNews[i].readerList.contains(widget.userInfo.uid)) {
        } else {
          if (unfilteredNews.length != 0 && unfilteredNews != null) {
            print('userUii: ' + j.toString());
            setState(() {
              news!.add(unfilteredNews[i]);
            });

            j++;
          }
        }
      }
    } else {
      // String checkType = '';
      // if (checkType == widget.type) {
      // } else {
      //   news!.clear();
      //   checkType = widget.type;
      //   print(checkType);
      // }
      // print('all except unread');

      setState(() {
        news = unfilteredNews;
      });
    }

    return news == null
        ? Center(
            child: SpinKitCircle(
            color: Colors.black,
            size: 50.0,
          ))
        : Container(
            child: news!.length == 0
                ? Center(
                    child: Text(
                        widget.type == 'home'
                            ? 'No News for now.'
                            : widget.type == 'bookmark'
                                ? 'No saved bookmarks.'
                                : 'No unread news for now.',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w600)),
                  )
                : TextContainer(
                    news: news!,
                    handleDragStart: handleDragStart,
                    handleDragUpdate: handleDragUpdate,
                    handleDragEnd: handleDragEnd,
                    pageStorageKeyValue: '1',
                    userInfo: widget.userInfo,
                    type: widget.type,
                    pageController: pageController,
                    callback: widget.callback),
          );
  }
}

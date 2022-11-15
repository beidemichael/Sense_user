import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:news_user/screens/newsPageWidgets/signInPopup.dart';
import 'package:ntp/ntp.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../models/models.dart';
import '../../service/database.dart';
import '../../service/time.dart';

class TextsAndContent extends StatefulWidget {
  News news;
  UserInformation userInfo;
  String type;
  final ValuesChanged<DragStartDetails, ScrollController> handleDragStart;
  final ValuesChanged<DragUpdateDetails, ScrollController> handleDragUpdate;
  final ValueChanged<DragEndDetails> handleDragEnd;
  final String pageStorageKeyValue;
  PageController? pageController;
  varCallback callback;

  TextsAndContent({
    super.key,
    required this.news,
    required this.handleDragStart,
    required this.handleDragUpdate,
    required this.handleDragEnd,
    required this.pageStorageKeyValue,
    required this.userInfo,
    required this.type,
    required this.pageController,
    required this.callback,
  })  : assert(handleDragStart != null),
        assert(handleDragUpdate != null),
        assert(handleDragEnd != null),
        assert(pageStorageKeyValue != null);
  @override
  _TextsAndContentState createState() => _TextsAndContentState();
}

class _TextsAndContentState extends State<TextsAndContent> {
  ScrollController? scrollController;
  ScreenshotController screenshotController = ScreenshotController();
  File? _imageFile;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.type == 'home') {
      // DatabaseService().newsRead(
      //   widget.userInfo.uid,
      //   news[index].documentId,
      // );
      print('New page');
    }
    timeNow();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController?.dispose();

    super.dispose();
  }

  String firstHalf = '';
  bool loading = true;
  DateTime now = DateTime.now();
  bool bookmark = false;
  ScrollController _semicircleController = ScrollController();

  timeNow() {
    now = DateTime.now();
    setState(() {
      loading = false;
    });
  }

  _takeScreenshotandShare() async {
    _imageFile;
    screenshotController
        .capture(delay: Duration(milliseconds: 10), pixelRatio: 4.0)
        .then((image) async {
      // setState(() {
      //   _imageFile = image;
      // });
      final directory = (await getTemporaryDirectory()).path;
      // Uint8List pngBytes = image?.readAsBytesSync();
      File imgFile = new File('$directory/screenshot.png');
      imgFile.writeAsBytes(image!);
      print("File Saved to Gallery");
      await Share.file('Anupam', 'screenshot.png', image, 'image/png',
          text:
              'Save time. Download "Name of App", to read news in short format.');
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    void whenCategoryUpDateTapped(String title) {
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: FractionallySizedBox(
                heightFactor: 0.2,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: SignInPopup(title: title),
                ),
              ),
            );
          });
    }

    return Screenshot(
      controller: screenshotController,
      child: Container(
        color: Colors.black,
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                Container(
                  //image
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: widget.news.image != ''
                      ? ClipRRect(
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: widget.news.image,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                              child: Container(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.grey[300]!),
                                    value: downloadProgress.progress),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.newspaper_rounded,
                            size: 150,
                            color: Colors.grey[400],
                          ),
                        ),
                ),
                Positioned(
                  top: 200.0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    decoration: BoxDecoration(
                        // gradient: new LinearGradient(
                        //   colors: [
                        //     Colors.white.withOpacity(0.0),
                        //     Colors.white.withOpacity(0.2),
                        //     Colors.white.withOpacity(0.4),
                        //     Colors.white.withOpacity(0.6),
                        //     Colors.white.withOpacity(0.8),
                        //     Colors.white.withOpacity(1)
                        //   ],
                        //   begin: Alignment.topCenter,
                        //   end: Alignment.bottomCenter,
                        // ),
                        ),
                  ),
                )
              ],
            ),
            Container(
              // height: 100,
              //heading
              // color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.news.headline,
                
                    style: TextStyle(
                        fontFamily: 'times',
                        fontSize: 20,
                        color: Colors.white,
                        height: 1.5,
                        fontWeight: FontWeight.w900)),
              ),
            ),
            Expanded(
              child: Container(
                //description

                // color: Colors.red,
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 8.0, left: 8, bottom: 8),
                  child: Scrollbar(
                    controller: _semicircleController,
                    child: GestureDetector(
                      onVerticalDragStart: (details) {
                        widget.handleDragStart(details, scrollController!);
                      },
                      onVerticalDragUpdate: (details) {
                        widget.handleDragUpdate(details, scrollController!);
                      },
                      onVerticalDragEnd: widget.handleDragEnd,
                      child: ListView(
                        key: PageStorageKey<String>(widget.pageStorageKeyValue),
                        physics: const NeverScrollableScrollPhysics(),
                        controller: scrollController,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(widget.news.description,

                                // maxLines: 4,
                                style: TextStyle(
                                  fontFamily: 'georgia',
                                    fontSize: 17,
                                    height: 1.5,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w400)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 35,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: Row(
                        children: [
                          Text(widget.news.author + " - ",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w300)),
                          loading == true
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: SpinKitThreeBounce(
                                          color: Colors.white,
                                          size: 10.0,
                                        ),
                                      ),
                                    ],
                                  ))
                              : Text(
                                  convertTimeStampp(
                                          widget.news.created
                                              .millisecondsSinceEpoch,
                                          now)
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w300)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLoading = true;
                        });
                        _takeScreenshotandShare();
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: Center(
                        child: isLoading
                            ? Center(
                                child: SpinKitCircle(
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                              )
                            : Icon(
                                Icons.share,
                                size: 30,
                                color: Colors.white,
                              ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (widget.userInfo.uid == '') {
                          whenCategoryUpDateTapped('bookmarking.');
                        } else {
                          if (widget.news.bookmarks
                              .contains(widget.userInfo.uid)) {
                            DatabaseService().unBookMark(
                              widget.userInfo.uid,
                              widget.news.documentId,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(milliseconds: 800),
                                elevation: 5,
                                backgroundColor: Colors.white,
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Unbookmarked',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            DatabaseService().bookMark(
                              widget.userInfo.uid,
                              widget.news.documentId,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(milliseconds: 800),
                                elevation: 5,
                                backgroundColor: Colors.white,
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Bookmarked',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          setState(() {
                            bookmark = !bookmark;
                          });
                        }
                      },
                      child: widget.news.bookmarks.contains(widget.userInfo.uid)
                          ? Icon(
                              Icons.bookmark,
                              size: 35,
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.bookmark_add_outlined,
                              size: 35,
                              color: Colors.white,
                            ),
                    ),
                  ],
                ),
              ),
              // color: Colors.blue[200],
            ),
          ],
        ),
      ),
    );
  }
}

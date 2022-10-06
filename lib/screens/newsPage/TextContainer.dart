import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../service/database.dart';
import '../newsPageWidgets/text_container.dart';

class TextContainer extends StatefulWidget {
  List<News> news;
  UserInformation userInfo;
  String type;
  final ValuesChanged<DragStartDetails, ScrollController> handleDragStart;
  final ValuesChanged<DragUpdateDetails, ScrollController> handleDragUpdate;
  final ValueChanged<DragEndDetails> handleDragEnd;
  final String pageStorageKeyValue;
  PageController? pageController;
  varCallback callback;

  TextContainer({
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
  State<TextContainer> createState() => _TextContainerState();
}

class _TextContainerState extends State<TextContainer> {
 

  _onPageViewChange(int page) {
    if (page != 0) {
      if (page <= widget.news.length) {
        Future.delayed(const Duration(seconds: 1), () {
          if (widget.userInfo.uid != '') {
            DatabaseService().newsRead(
              widget.userInfo.uid,
              widget.news[page - 1].documentId,
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          onPageChanged: _onPageViewChange,
          controller: widget.pageController,
          allowImplicitScrolling: true,
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          scrollDirection: Axis.vertical,
          // physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.news.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: index > widget.news.length - 1
                  ? Container(
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * .5,
                          child: Text('You are now updated with all the news',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    )
                  : TextsAndContent(
                      news: widget.news[index],
                      handleDragStart: widget.handleDragStart,
                      handleDragUpdate: widget.handleDragUpdate,
                      handleDragEnd: widget.handleDragEnd,
                      pageStorageKeyValue: '1',
                      userInfo: widget.userInfo,
                      type: widget.type,
                      pageController: widget.pageController,
                       callback: widget.callback
    
                      ),
            );
          },
        ),
        Positioned(
          right: 0.0,
          top: -10.0,
          child: GestureDetector(
            onTap: () {
              // widget.pageController!.jumpToPage(0); // for regular jump
              widget.pageController!.animateToPage(0,
                  curve: Curves.decelerate,
                  duration: Duration(
                      milliseconds:
                          400)); // for animated jump. Requires a curve and a duration
              widget.callback(null);
            },
            child: Container(
              height: 50,
              width: 50,
              child: Icon(Icons.arrow_drop_up,
                  color: Colors.grey.shade100, size: 40),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(0),
                    bottomLeft: Radius.circular(25)),
              ),
            ),
          ),
        )
      ],
    );
  }
}

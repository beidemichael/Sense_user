import 'package:flutter/material.dart';

import '../../models/models.dart';

class NewsCard extends StatefulWidget {
  News news;
  NewsCard({super.key, required this.news});

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // TextsAndContent(
          
        //   news: widget.news,
        //   // now: now,
        //   // loading: loading,
        // )
      ],
    );
  }
}

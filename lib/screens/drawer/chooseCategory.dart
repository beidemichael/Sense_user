import 'dart:math';

import 'package:chip_list/chip_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../service/database.dart';
import '../../service/auth.dart';

class ChooseCategory extends StatefulWidget {
  List<String> categories;
  String uid;
  ChooseCategory({required this.categories, required this.uid});

  @override
  _ChooseCategoryState createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends State<ChooseCategory> {
  bool _isSigningIn = false;
  List<int> selectedIndex = [1000];
  List<String> newList = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: ListView(
            children: [
              ChipList(
                listOfChipNames: widget.categories,
                activeBgColorList: [Colors.grey.shade500],
                inactiveBgColorList: [Colors.grey.shade100],
                activeTextColorList: [Colors.black],
                inactiveTextColorList: [Colors.grey],
                listOfChipIndicesCurrentlySeclected: selectedIndex,
                shouldWrap: true,
                runSpacing: 0,
                spacing: 0,
                supportsMultiSelect: true,
                extraOnToggle: (val) {
                  selectedIndex.add(val);
                  if (newList.contains(widget.categories[val])) {
                  } else {
                    newList.add(widget.categories[val]);
                  }
                  setState(() {});
                },
                activeBorderColorList: [Colors.grey.shade500],
                inactiveBorderColorList: [Colors.grey.shade100],
              ),
              SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () async {
                  if (newList.length == 0 || newList == null) {
                    Navigator.of(context).pop();
                  } else {
                    if (newList.length > 10) {
                      newList = newList.sublist(0, 10);
                    }
                    await DatabaseService().userCategory(widget.uid, newList);
                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Center(
                      child: Text(
                        "Ok",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:chip_list/chip_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../service/auth.dart';
import '../../service/database.dart';
import '../newsPageWidgets/signInPopup.dart';
import 'chooseCategory.dart';

class DrawerContent extends StatefulWidget {
  bool signedIn;
  StringCallback callback;
  varCallback varcallback;

  String type;
  DrawerContent(
      {Key? key,
      required this.signedIn,
      required this.callback,
      required this.type,
      required this.varcallback})
      : super(key: key);

  @override
  State<DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  bool _isSigningOut = false;
  String displayName = '';
  String email = '';
  bool isAnonymous = false;
  String phoneNumber = '';
  String photoURL = '';
  String uid = '';
  List<String> finalCategory = [];
  List<String> categoryString = [];
  List<String> categoryString2 = [];
  var _items;
  var _items2;

  listToMap2(List categoryList) {
    categoryString.clear();
    for (int i = 0; i < categoryList.length; i++) {
      categoryString.add(categoryList[i]);
    }
    if (_items2 != null) {
      _items2.clear();
    }
  }

  listToList(List categoryList) {
    categoryString2.clear();
    for (int i = 0; i < categoryList.length; i++) {
      categoryString2.add(categoryList[i]);
    }
    return categoryString2;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bool _isSigningOut = false;
    String displayName = '';
    String email = '';
    bool isAnonymous = false;
    String phoneNumber = '';
    String photoURL = '';
    String uid = '';
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<List<UserInformation>>(context);
    final newsCategory = Provider.of<List<NewsCategory>>(context);
    if (newsCategory != null && newsCategory.length != 0) {
      setState(() {
        listToMap2(_user[0].category);
      });
    }
    if (_user.length != 0 && widget.signedIn) {
      displayName = _user[0].displayName;
      email = _user[0].email;
      isAnonymous = _user[0].isAnonymous;
      phoneNumber = _user[0].phoneNumber;
      photoURL = _user[0].photoURL;
      uid = _user[0].uid;
    }
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

    void chooseCategory(String uid) {
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: FractionallySizedBox(
                heightFactor: 0.5,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: ChooseCategory(
                    categories: listToList(newsCategory[0].category),
                    uid: uid,
                  ),
                ),
              ),
            );
          });
    }

    return Container(
      color: Color.fromARGB(255, 33, 48, 65),
      width: MediaQuery.of(context).size.width * 0.7,
      child: ListView(
        children: [
          Column(
            children: [
              SizedBox(height: 40.0),
              photoURL != ''
                  ? ClipOval(
                      child: Material(
                        color: Colors.white,
                        child: Image.network(
                          photoURL,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    )
                  : ClipOval(
                      child: Material(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Color(0xFF98AAD6),
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 20.0),
              Text(
                displayName,
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '${email}',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 16.0),
              _isSigningOut
                  ? Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        color: Color(0xFF98AAD6),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Center(
                          child: SpinKitCircle(
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () async {
                        if (email == '') {
                          setState(() {
                            _isSigningOut = true;
                          });
                          AuthServices.initializeFirebase(context: context);
                          User? user = await AuthServices.signInWithGoogle(
                              context: context);
                          setState(() {
                            _isSigningOut = false;
                          });
                          Navigator.of(context).pop();

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: Duration(milliseconds: 800),
                              elevation: 5,
                              backgroundColor: Color(0xFF98AAD6),
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Signed in :)',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              )));
                        } else {
                          setState(() {
                            _isSigningOut = true;
                          });

                          await AuthServices.signOut(context: context);
                          setState(() {
                            _isSigningOut = false;
                          });
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: Duration(milliseconds: 800),
                              elevation: 5,
                              backgroundColor: Color(0xFF98AAD6),
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Signed out :(',
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
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.6,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 17, 27, 39),
                          // border: Border.all(
                          //     width: 1, color: Colors.red.shade100),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Center(
                            child: Text(
                              email == '' ? "Sign In" : "Sign Out",
                              style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () {
                        widget.callback("home");
                        widget.varcallback(null);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: widget.type == 'home'
                            ? BoxDecoration(
                                color: Color.fromARGB(255, 50, 75, 102),
                                borderRadius: widget.type == 'home'
                                    ? BorderRadius.all(Radius.circular(15))
                                    : null,
                              )
                            : null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15.0, right: 5),
                              child: Icon(
                                FontAwesomeIcons.house,
                                size: 15.0,
                                color: widget.type == 'home'
                                    ? Colors.grey.shade200
                                    : Colors.grey.shade400,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 8.0, bottom: 8.0, left: 12),
                              child: Text(
                                'Home',
                                style: TextStyle(
                                    color: widget.type == 'home'
                                        ? Colors.grey.shade200
                                        : Colors.grey.shade400,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () {
                        widget.callback("unread");
                        widget.varcallback(null);
                        Navigator.of(context).pop();
                      },
                      child: Stack(
                        children: [
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.5,
                            decoration: widget.type == 'unread'
                                ? BoxDecoration(
                                    color: Color.fromARGB(255, 50, 75, 102),
                                    borderRadius: widget.type == 'unread'
                                        ? BorderRadius.all(Radius.circular(15))
                                        : null,
                                  )
                                : null,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 8.0, bottom: 8.0, left: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5.0, right: 15),
                                    child: Icon(
                                      FontAwesomeIcons.solidNewspaper,
                                      size: 15.0,
                                      color: widget.type == 'home'
                                          ? Colors.grey.shade200
                                          : Colors.grey.shade400,
                                    ),
                                  ),
                                  Text(
                                    'Unread News',
                                    style: TextStyle(
                                        color: widget.type == 'unread'
                                            ? Colors.grey.shade200
                                            : Colors.grey.shade400,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () {
                        if (widget.signedIn) {
                          widget.callback("bookmarks");
                          widget.varcallback(null);
                          Navigator.of(context).pop();
                        } else {
                          whenCategoryUpDateTapped('viewing bookmarks.');
                        }
                      },
                      child: Stack(
                        children: [
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.5,
                            decoration: widget.type == 'bookmarks'
                                ? BoxDecoration(
                                    color: Color.fromARGB(255, 50, 75, 102),
                                    borderRadius: widget.type == 'bookmarks'
                                        ? BorderRadius.all(Radius.circular(15))
                                        : null,
                                  )
                                : null,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 8.0, bottom: 8.0, left: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5.0, right: 15),
                                    child: Icon(
                                      FontAwesomeIcons.solidBookmark,
                                      size: 15.0,
                                      color: widget.type == 'home'
                                          ? Colors.grey.shade200
                                          : Colors.grey.shade400,
                                    ),
                                  ),
                                  Text(
                                    'Bookmarks',
                                    style: TextStyle(
                                        color: widget.type == 'bookmarks'
                                            ? Colors.grey.shade200
                                            : Colors.grey.shade400,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () {
                        if (widget.signedIn) {
                          chooseCategory(_user[0].uid);
                        } else {
                          whenCategoryUpDateTapped('choosing category.');
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 33, 48, 65),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          border: Border.all(
                              width: 1,
                              color: Color.fromARGB(255, 39, 90, 141)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, bottom: 8.0, left: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5.0, right: 15),
                                    child: Icon(
                                      FontAwesomeIcons.list,
                                      size: 15.0,
                                      color: widget.type == 'home'
                                          ? Colors.grey.shade200
                                          : Colors.grey.shade400,
                                    ),
                                  ),
                                  Text(
                                    "Category",
                                    style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            ChipList(
                              listOfChipNames: categoryString,
                              activeBgColorList: [
                                Color.fromARGB(255, 50, 75, 102),
                              ],
                              inactiveBgColorList: [
                                Color.fromARGB(255, 50, 75, 102),
                              ],
                              activeTextColorList: [Colors.white],
                              inactiveTextColorList: [Colors.white],
                              listOfChipIndicesCurrentlySeclected: [0],
                              shouldWrap: true,
                              runSpacing: 0,
                              spacing: 0,
                              activeBorderColorList: [
                                Color.fromARGB(255, 50, 75, 102),
                              ],
                              inactiveBorderColorList: [
                                Color.fromARGB(255, 50, 75, 102),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () {
                        widget.callback("aboutUs");
                        Navigator.of(context).pop();
                      },
                      child: Stack(
                        children: [
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.5,
                            decoration: widget.type == 'aboutUs'
                                ? BoxDecoration(
                                    color: Color.fromARGB(255, 50, 75, 102),
                                    borderRadius: widget.type == 'aboutUs'
                                        ? BorderRadius.all(Radius.circular(15))
                                        : null,
                                  )
                                : null,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 8.0, bottom: 8.0, left: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5.0, right: 15),
                                    child: Icon(
                                      FontAwesomeIcons.circleInfo,
                                      size: 15.0,
                                      color: widget.type == 'home'
                                          ? Colors.grey.shade200
                                          : Colors.grey.shade400,
                                    ),
                                  ),
                                  Text(
                                    'About Us',
                                    style: TextStyle(
                                        color: widget.type == 'aboutUs'
                                            ? Colors.grey.shade200
                                            : Colors.grey.shade400,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

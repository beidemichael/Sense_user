import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../service/database.dart';
import 'drawer/drawer.dart';

class PublishScreen extends StatefulWidget {
  const PublishScreen({Key? key}) : super(key: key);

  @override
  State<PublishScreen> createState() => _PublishScreenState();
}

class _PublishScreenState extends State<PublishScreen> {
  final _formKey = GlobalKey<FormState>();
  final fieldTextHeadline = TextEditingController();
   final fieldTextDesctipion = TextEditingController();
  String headline = "";
  String description = "";
  String source = "";
  List<String> selected = [];
  List<String> category = [];
  List<String> categoryexample = [
    'Politics',
    'Entertainment',
    'Sports',
    'Financials',
    'Social',
    'Technology',
    'Science',
    'Biology',
    'Automotors',
    'Infrastracture',
  ];
  List<Category> categoryMap = [];
  listToMap() {
    for (int i = 0; i < categoryexample.length; i++) {
      categoryMap.addAll({Category(id: i + 1, cat: categoryexample[i])});
    }
  }

  void clearText() {
    fieldTextHeadline.clear();
    fieldTextDesctipion.clear();
  }

  @override
  void initState() {
    super.initState();
    listToMap();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserAuth?>(context);
    GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
    final _items = categoryMap
        .map((mapCategory) =>
            MultiSelectItem<Category>(mapCategory, mapCategory.cat))
        .toList();
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Admin App',
        ),
        backgroundColor: const Color(0xff764abc),
      ),
      // drawer: DrawerContent(),
      body: Stack(
        children: [
          Center(
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: TextFormField(
                      controller: fieldTextHeadline,
                      validator: (val) => val!.length != 6
                          ? 'Code should be 6 digits long'
                          : null,
                      textAlign: TextAlign.left,
                      onChanged: (val) {
                        setState(() {
                          headline = val;
                        });
                      },
                      maxLength: 50,
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        labelText: 'Headline',
                        labelStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400),
                        focusColor: Colors.purple[900],
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.grey[400]!)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.purple[400]!)),
                        errorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.purple[400]!)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.purple[400]!)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    child: TextFormField(
                      controller: fieldTextDesctipion,
                      validator: (val) => val!.length != 6
                          ? 'Code should be 6 digits long'
                          : null,
                      textAlign: TextAlign.left,
                      onChanged: (val) {
                        setState(() {
                          description = val;
                        });
                      },
                      maxLength: 250,
                      keyboardType: TextInputType.multiline,
                      maxLines: 7,
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400),
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        labelText: 'Description',
                        labelStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400),
                        focusColor: Colors.purple[900],
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.grey[400]!)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.purple[400]!)),
                        errorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.purple[400]!)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.purple[400]!)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        // color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                          color: Colors.grey[400]!,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Text(
                              "Image",
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 90,
                            child: Icon(
                              Icons.cloud_upload,
                              color: Colors.purple,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.purple[100],
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(9),
                                  topRight: Radius.circular(9)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    child: MultiSelectDialogField(
                      items: _items.toList(),
                      title: Text("Category"),
                      buttonIcon: Icon(
                        Icons.select_all_rounded,
                        color: Colors.purple,
                      ),
                      selectedColor: Colors.purple[500],
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                          color: Colors.purple[200]!,
                          width: 1,
                        ),
                      ),
                      buttonText: Text(
                        "Select Category",
                        style: TextStyle(
                            color: Colors.purple[200],
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400),
                      ),
                      onConfirm: (List<Category> results) {
                        category.clear();
                        results.forEach((e) => category.add(e.cat));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: GestureDetector(
                      onTap: () {
                        // DatabaseService().publishNews(
                        //   headline,
                        //   description,
                        //   '',
                        //   category,
                        // );
                        clearText();
                      },
                      child: Container(
                        height: 60,
                        child: Center(
                          child: Text(
                            "Publish",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

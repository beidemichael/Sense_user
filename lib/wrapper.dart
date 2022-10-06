import 'package:flutter/material.dart';
import 'package:news_user/screens/homePage.dart';
import 'package:news_user/service/database.dart';
import 'package:provider/provider.dart';
import 'models/models.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool signedIn = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserAuth?>(context);
    if (user == null) {
      setState(() {
        signedIn = false;
      });
    } else {
      setState(() {
        signedIn = true;
      });
    }
    return StreamProvider<List<UserInformation>>.value(
        value: DatabaseService(userUid: user?.uid).userInfo,
        initialData: [],
        child: user == null
            ? HomePage(signedIn: signedIn, userUid: 'ghgh')
            : HomePage(signedIn: signedIn, userUid: user.uid));
  }
}

import 'package:flutter/material.dart';
import 'package:news_user/firebase_options.dart';
import 'package:news_user/screens/drawer/drawer.dart';
import 'package:news_user/screens/homePage.dart';
import 'package:news_user/screens/newsPage/newsPage.dart';
import 'package:news_user/service/auth.dart';
import 'package:news_user/service/database.dart';
import 'package:news_user/wrapper.dart';
import 'package:provider/provider.dart';
import 'models/models.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Firebase.apps;
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Sense",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: MultiProvider(
          providers: [
            StreamProvider<UserAuth?>.value(
              value: AuthServices().user,
              initialData: null,
            ),
          ],
          child: const Wrapper(),
        ),
      ),
    );
  }
}

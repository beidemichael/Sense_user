import 'package:flutter/material.dart';
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
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      name: 'news-app',
      options: FirebaseOptions(
          apiKey: "AIzaSyBznVCV8V9bdt-uSf-na4tt_OMHQCGRoDo",
          authDomain: "news-app-329ee.firebaseapp.com",
          projectId: "news-app-329ee",
          storageBucket: "news-app-329ee.appspot.com",
          messagingSenderId: "353768279389",
          appId: "1:353768279389:web:8d1941faf99d8c4a8eecb4",
          measurementId: "G-KXCSD63ZYW"),
    );
  }
  runApp(const MaterialApp(
      title: "Sense",
      debugShowCheckedModeBanner: false, home: MyApp()));
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

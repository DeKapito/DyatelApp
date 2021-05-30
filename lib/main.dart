import 'package:dyatel_app/home_screen.dart';
import 'package:dyatel_app/loading_screen.dart';
import 'package:dyatel_app/services/DatabaseHandler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

void main() => runApp(MyApp());

DatabaseHandler handler = DatabaseHandler();

Future<int> initApp() async {
  await Firebase.initializeApp();
  await handler.initializeDB();
  return 1;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("Error");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          User user = FirebaseAuth.instance.currentUser;
          Widget renderPage = user == null ? LoginScreen() : HomeScreen();

          return MaterialApp(
            title: 'Flutter Login',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: renderPage,
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return LoadingScreen();
      },
    );
  }
}

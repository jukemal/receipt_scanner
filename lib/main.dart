import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receiptscanner/services/database_service.dart';

import 'service_locator.dart';
import 'services/auth_service.dart';
import 'wrapper.dart';

void main() {
  setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider.value(value: FirebaseAuth.instance.onAuthStateChanged),
        Provider.value(value: AuthService()),
        Provider.value(value: DatabaseService()),
      ],
      child: MaterialApp(
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: //StartScreen(),//
            SScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

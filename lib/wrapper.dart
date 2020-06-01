import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'login.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

class SScreen extends StatefulWidget {
  @override
  _SScreenState createState() => _SScreenState();
}

class _SScreenState extends State<SScreen> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 3,
        navigateAfterSeconds: new Wrapper(),
        image: Image.asset('images/logo.png'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        loaderColor: Colors.green
    );
  }
}

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    if(user == null){
      return Login();
    } else {
      return Home();
    }
  }
}

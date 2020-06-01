import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:receiptscanner/register.dart';
import 'package:receiptscanner/services/auth_service.dart';
import 'package:receiptscanner/shared/loading.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  bool loading = false;

  // variables for text fields
  String email = '';
  String password = '';

  //String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            darkTheme: ThemeData(
              brightness: Brightness.dark,
            ),
            home: Scaffold(
                resizeToAvoidBottomPadding: false,
                body: Container(
                  //margin: EdgeInsets.only( bottom: 135),
                  constraints: BoxConstraints(),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'images/logo_light.png',
                        //height: 170,
                        //width: 170,
                        //color: Colors.fromRGBO(	0, 153, 0, 100),),
                        //color: Colors.white.withOpacity(0.6),

                        //fit: BoxFit.cover
                      ),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    child: LayoutBuilder(builder: (BuildContext context,
                        BoxConstraints viewportConstraints) {
                      return Scrollbar(
                        child: SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: viewportConstraints.maxHeight,
                              minWidth: viewportConstraints.maxWidth,
                            ),
                            child: ListBody(
                              mainAxis: Axis.vertical,
                              children: <Widget>[
                                title(viewportConstraints),
                                form(viewportConstraints),
                                //textError(),
                                textAccount(),
                                buttonRegister(context),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                )

                //),
                ),
          );
  }

  // Title login
  Container text(String text) {
    return Container(
        margin: EdgeInsets.only(left: 15, bottom: 15, top: 5),
        child: Text(text, style: GoogleFonts.roboto(fontSize: 18)));
  }

  Container title(BoxConstraints viewportConstraints) {
    return Container(
      constraints: BoxConstraints(minWidth: viewportConstraints.maxWidth),
      //margin: EdgeInsets.only(top: 30),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 54, 0, 55),
        child: Text("Login",
            //textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
                color: Colors.black, letterSpacing: 4, fontSize: 38)),
      ),
    );
  }

// form
  Container form(BoxConstraints viewportConstraints) {
    return Container(
      constraints: BoxConstraints(minWidth: viewportConstraints.maxWidth),
      margin: EdgeInsets.only(top: 30),
      child: Form(
        key: _formKey,
        child: Container(
          constraints: BoxConstraints(minWidth: viewportConstraints.maxWidth),
          margin: EdgeInsets.only(left: 25, right: 25),
          child: ListBody(
            mainAxis: Axis.vertical,
            children: <Widget>[
              //text("Email"),
              textFormFieldEmail(),
              //text("Password"),
              textFormFieldPassword(),
              button(),
            ],
          ),
        ),
      ),
    );
  }

  // Email Textfield
  Container textFormFieldEmail() {
    return Container(
      margin: EdgeInsets.only(
        bottom: 30,
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: 'Email',
          prefixIcon: Icon(
            Icons.email,
            color: Colors.green,
          ),
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(color: Colors.black, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.green, width: 2),
          ),
          //border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
        validator: (value) {
          if (value.isEmpty ||
              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value)) {
            return 'Please enter valid email address';
          } else {
            setState(() {
              email = value;
            });
            return null;
          }
        },
      ),
    );
  }

  // Password textfield
  Container textFormFieldPassword() {
    return Container(
      margin: EdgeInsets.only(
        bottom: 25,
      ),
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Password',
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.green,
          ),
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(color: Colors.black, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.green, width: 2),
          ),
          //border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
        validator: (value) {
          if (value.isEmpty || value.length < 6) {
            return 'Please enter password with more than 6 characters';
          } //else if (value.length < 6) {
          //return "Length should be more than 6";
          //}
          else {
            setState(() {
              password = value;
            });
            return null;
          }
        },
      ),
    );
  }

// Login button
  Container button() {
    return Container(
      margin: EdgeInsets.only(
        top: 40,
      ),
      child: Material(
        elevation: 5.0,
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
        child: MaterialButton(
          child: Text(
            "Login",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              setState(() {
                loading = true;
              });

              bool result =
                  await Provider.of<AuthService>(context, listen: false)
                      .loginWithEmail(email: email, password: password);
              if (result == null) {
                setState(() {
                  //error = 'could not sign in';
                  loading = false;
                });

                Fluttertoast.showToast(
                  msg: "Could not sign in",
                  toastLength: Toast.LENGTH_LONG,
                );
              }
            }
          },
        ),
      ),
    );
  }

/*
  Container textError() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: GestureDetector(
        child: Text(
          error,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red, fontSize: 14.0),
        ),
      ),
    );
  }

 */

  //  Container textAccount() {
  //    return Container(
  //      margin: EdgeInsets.only(top: 40),
  //      child: Text(
  //        "Don't have an account?",
  //        textAlign: TextAlign.center,
  //      ),
  //    );
  //  }
  //}

// Register page link
  Container buttonRegister(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 35),
      child: InkWell(
        onTap: () {
          //loading = true;
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Register()));
        },
        child: Text(
          "Create Account",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Container textAccount() {
    return Container(
      margin: EdgeInsets.only(top: 40),
      child: Text(
        "Don't have an account?",
        textAlign: TextAlign.center,
      ),
    );
  }
}

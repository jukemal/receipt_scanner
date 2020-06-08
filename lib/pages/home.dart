import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:receiptscanner/pages/reminder_list.dart';

import 'camera_view.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Center(
            child: Text(
              "Home",
              textAlign: TextAlign.center,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Logout"),
                        content: Text("Do you want to logout?"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                              await FirebaseAuth.instance.signOut();
                            },
                          ),
                          FlatButton(
                            child: Text(
                              "No",
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              },
            )
          ],
        ),
        body: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
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
                    Image.asset(
                      "images/image1.jpg",
                      width: viewportConstraints.maxWidth,
                      fit: BoxFit.fitWidth,
                    ),
                    Container(
                      constraints: BoxConstraints(
                          minWidth: viewportConstraints.maxWidth),
                      margin: EdgeInsets.only(left: 10, right: 10, top: 15),
                      child: ListBody(
                        mainAxis: Axis.vertical,
                        children: <Widget>[
                          InkWell(
                            child: Card(
                              child: ListBody(
                                mainAxis: Axis.vertical,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Icon(
                                      Icons.insert_drive_file,
                                      size: 80,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Container(
                                      margin:
                                          EdgeInsets.only(top: 10, bottom: 20),
                                      child: Text(
                                        " Take Photo",
                                        textAlign: TextAlign.center,
                                      ))
                                ],
                              ),
                            ),
                            onTap: () async {
                              File image;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CameraView()));
                            },
                          ),
                          InkWell(
                            child: Card(
                              child: ListBody(
                                mainAxis: Axis.vertical,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Icon(
                                      Icons.list,
                                      size: 80,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Container(
                                      margin:
                                          EdgeInsets.only(top: 10, bottom: 20),
                                      child: Text(
                                        "View List",
                                        textAlign: TextAlign.center,
                                      ))
                                ],
                              ),
                            ),
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ReminderList()));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

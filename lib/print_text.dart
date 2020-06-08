import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:receiptscanner/models/receipt.dart';
import 'package:receiptscanner/services/database_service.dart';

class PrintText extends StatefulWidget {
  final List<String> lines;
  final List<String> words;

  PrintText({@required this.lines, this.words});

  @override
  _PrintTextState createState() => _PrintTextState();
}

class _PrintTextState extends State<PrintText> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          "Recognized Text",
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: widget.lines.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(5, 15, 0, 0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text(widget.lines[index]),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10, top: 5),
            child: RaisedButton(
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.green,
                onPressed: () async {
                  Map<String, int> itemList = Map();

                  for (int i = 1; i < widget.lines.length; i++) {
                    List<String> wordList =
                        widget.lines[i].split(RegExp(r" +"));
                    try {
                      if (wordList[1].contains(RegExp(r'^[a-zA-Z\s]+$'))) {
                        itemList[wordList[1].toLowerCase()] =
                            int.parse(wordList[4].substring(0, 1));
                      }
                    } catch (e) {}
                  }

                  itemList.forEach(
                      (key, value) => print("item : $key, quantity : $value"));

                  if (itemList.entries.length > 0) {
                    await Provider.of<DatabaseService>(context, listen: false)
                        .addReceipt(Receipt(
                            timeStamp: DateTime.now(), itemList: itemList));

                    Fluttertoast.showToast(msg: "Successfully Added.");
                  }
                  Navigator.pop(context);
                  Navigator.pop(context);

                  Provider.of<DatabaseService>(context, listen: false)
                      .generateShoppingList();
                }),
          ),
        ],
      ),
    );
  }
}

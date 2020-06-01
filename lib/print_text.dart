import 'package:flutter/material.dart';

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
			  margin: EdgeInsets.only(bottom: 10,top: 5),
            child: RaisedButton(
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.green,
                onPressed: () {
//							String receiptID;
//							final CollectionReference receiptcollection = Firestore
//								.instance.collection('receipts');
//
//							receiptcollection.add({
//								'date': DateTime.now(),
//
//							}).then((document) => {
//							receiptID = document.documentID;
//							});
//							for (List<String> receipt in inputList) {
//								print('got receipt' + receipt[0]);
//								receiptcollection.document(receiptID).setData(
//									{'products': [receipt[0], receipt[1]]});
//							}
                }),
          )
        ],
      ),
    );
  }
}

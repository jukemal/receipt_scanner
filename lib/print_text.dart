import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class PrintText extends StatefulWidget {

	List <String> scannedText;
	List <List<String>> inputList;


	PrintText(this.scannedText, this.inputList);

	@override
	_PrintTextState createState() => _PrintTextState(scannedText, inputList);
}

class _PrintTextState extends State<PrintText> {

	List <String> scannedText;
	List <List<String>> inputList;


	_PrintTextState(this.scannedText, this.inputList);

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				backgroundColor: Colors.green,
				title: Text(
					"Recognized Text",
				),

				leading: IconButton(
					icon: Icon(Icons.arrow_back),
					onPressed: () async {
						Navigator.pop(context);
					},
				),
			),
			body: Column(
				children: <Widget>[
					Expanded(
						child: ListView.builder(itemCount: scannedText.length,
							itemBuilder: (BuildContext ctxt, int index) {
								return Padding(
									padding: const EdgeInsets.fromLTRB(
										5, 15, 0, 0),
									child: new
									Row(mainAxisAlignment: MainAxisAlignment
										.center,
										children: <Widget>[
											Center(
												child: Text(scannedText[index]),
											),

										],
									),
								);
							},
						),
					),
					RaisedButton(
						child: Text('Save',
							style: TextStyle(
								color: Colors.white,
							),),
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
						}
					)
				],
			),
		);
	}
}

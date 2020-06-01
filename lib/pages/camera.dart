import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:receiptscanner/print_text.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  File pickedImage;

  bool isImageLoaded = false;

  Future pickImage() async {
    var tempStore = await ImagePicker.pickImage(source: ImageSource.camera);
    //var tempStore = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      pickedImage = tempStore;
      isImageLoaded = true;
    });

  }


  Future readText() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {

          String detectedLine = line.text;
          scannedWords.add(detectedLine);

          List<String> detectedWords = new List<String>();

          for(TextElement word in line.elements) {

            detectedWords.add(word.text);
          }
          inputs.add(detectedWords);
      }
    }
  }
  List <List<String>> inputs = new List<List<String>>();
  List <String> scannedWords = new List<String>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: <Widget>[
          isImageLoaded ?
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 40),
              height: 200.0,
              width: 200.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: FileImage(pickedImage), fit: BoxFit.cover
                ),
              ),
            ),
          ): Container(),

          SizedBox(
            height: 170.0,
          ),

          RaisedButton(
            child: Text('Capture image',
              style: TextStyle(
                color: Colors.white,
              ),),
            onPressed: pickImage,
            color: Colors.green,
          ),

          SizedBox(
            height: 10.0,
          ),

          RaisedButton(
            child: Text(
              'Read Text',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              await readText();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => PrintText(scannedWords,inputs)));
            },
            //onPressed: readText,
            color: Colors.green,
          )
        ],
      ),
    );
  }
}

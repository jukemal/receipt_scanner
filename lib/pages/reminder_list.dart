import 'package:flutter/material.dart';
import 'package:receiptscanner/pages/home.dart';
import 'package:receiptscanner/groceryItem.dart';


class Reminder_List extends StatelessWidget {

 // final items = List<String>.generate(10000, (i) => "Item $i");
  final itemList = [
    new Groceryitem("Rice", "2 days"),
    new Groceryitem("Sugar", "1 day"),
    new Groceryitem("Milk", "2 days"),
    new Groceryitem("Bread", "2 days"),
    new Groceryitem("Flour", "1 day"),
    new Groceryitem("Butter", "2 days"),
  ];
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(

        appBar : AppBar(
          backgroundColor: Colors.green,
          title: Text(
                "Reminder List",
              //textAlign: TextAlign.center,
            ),

          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
            },
          ),
        ),
        body: ListView.builder(
            itemCount: itemList.length,//items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          itemList[index].PName,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                            //"Rice"
                        ),
                        Text(
                          itemList[index].Pdays,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                            //"2 days"
                        )
                      ],
                    ),
                  ],
                ),
              );
            }
        ),
      ),
    );

  }
}

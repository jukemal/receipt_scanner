import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receiptscanner/services/database_service.dart';

class ReminderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          "Reminder List",
        ),
      ),
      body: FutureBuilder<List<ListItem>>(
        future: Provider.of<DatabaseService>(context, listen: false)
            .getUserWithRecommendedList(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ListItem>> snapshot) {
          Widget widget;
          if (snapshot.hasData) {
            List<ListItem> list = snapshot.data;
            widget = ListView.builder(
                itemCount: list.length, //items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              list[index].item,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              list[index].days <= 5
                                  ? "${list[index].days} Days"
                                  : "Buy",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            widget = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  )
                ],
              ),
            );
          } else {
            widget = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  ),
                ],
              ),
            );
          }
          return widget;
        },
      ),
    );
  }
}

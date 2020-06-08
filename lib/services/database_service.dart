import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mock_data/mock_data.dart';
import 'package:receiptscanner/models/receipt.dart';

import '../models/user.dart';

class DatabaseService {
  final CollectionReference _userCollection =
      Firestore.instance.collection('users');

  Future createUser(User user) async {
    try {
      FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
      await _userCollection
          .document(firebaseUser.uid)
          .setData(User.userToFireStore(user));
      createDummyReceipts();
    } catch (e) {
      return e.toString();
    }
  }

  Future<User> getUser(String id) async {
    try {
      return await _userCollection.document(id).get().then((value) {
        User user = User.fromFireStore(value);
        return user;
      });
    } catch (e) {
      return null;
    }
  }

  Future<List<ListItem>> getUserWithRecommendedList() async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

    try {
      if (firebaseUser != null) {
        return await _userCollection
            .document(firebaseUser.uid)
            .get()
            .then((value) {
          User user = User.fromFireStoreWithRecommendationList(value);
          List<ListItem> list = [];
          user.list.forEach((key, value) {
            list.add(ListItem(
                item: key
                    .split(' ')
                    .map((e) => e[0].toUpperCase() + e.substring(1))
                    .join(' '),
                days: DateTime.now().difference(value).inDays));
          });
          return list.where((element) => element.days >= 0).toList();
        });
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> addReceipt(Receipt receipt) async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

    CollectionReference collectionReferenceReceipts = Firestore.instance
        .collection('users')
        .document(firebaseUser.uid)
        .collection('receipts');

    await collectionReferenceReceipts.add(Receipt.receiptToFireStore(receipt));

    return true;
  }

  Future<void> generateShoppingList() async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

    CollectionReference collectionReferenceReceipts = Firestore.instance
        .collection('users')
        .document(firebaseUser.uid)
        .collection('receipts');

    DocumentReference documentReferenceUser =
        Firestore.instance.collection('users').document(firebaseUser.uid);

    List<Receipt> receiptList = [];

    await collectionReferenceReceipts.getDocuments().then((value) async {
      for (DocumentSnapshot d in value.documents) {
        receiptList.add(Receipt.fromFireStore(d));
      }
    });

    receiptList.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));

    Map<String, Map<DateTime, int>> itemList = Map();

    for (Receipt r in receiptList) {
      for (MapEntry<String, int> item in r.itemList.entries) {
        if (itemList.containsKey(item.key)) {
          Map<DateTime, int> map = itemList[item.key];
          map[r.timeStamp] = item.value;
          itemList[item.key] = map;
        } else {
          Map<DateTime, int> map = Map();
          map[r.timeStamp] = item.value;
          itemList[item.key] = map;
        }
      }
    }

    // Item frequency grater than 1.
    Map<String, Map<DateTime, int>> filteredItemList = Map();

    for (MapEntry<String, Map<DateTime, int>> item in itemList.entries) {
      if (item.value.length > 1) {
        filteredItemList[item.key] = item.value;
      }
    }

    Map<String, DateTime> recommendedBuyingList = Map();

    for (MapEntry<String, Map<DateTime, int>> m in filteredItemList.entries) {
      String item = m.key;
      List<MapEntry<DateTime, int>> dateList = m.value.entries.toList();
      double sum = 0;

      for (int i = 1; i < dateList.length; i++) {
        sum += (dateList[i].key.difference(dateList[i - 1].key).inDays) /
            dateList[i - 1].value;
      }

      double avg = sum / (dateList.length - 1);
      int days = (avg * dateList.last.value).round();
      DateTime endDate = dateList.last.key.add(Duration(days: days));
      recommendedBuyingList[item] = endDate;
      print("item : $item, date : $endDate");
    }

    await documentReferenceUser
        .updateData({"recommended_list": recommendedBuyingList});
  }

  void createDummyReceipts() async {
    List<String> foodList = [
      'milk',
      'butter',
      'eggs',
      'sour cream',
      'sliced cheese',
      'shredded cheese',
      'ribeye',
      'chicken thighs',
      'chicken breasts',
      'ground turkey',
      'ground beef',
      'porkchops',
      'beer',
      'seltzer',
      'red wine',
      'white wine',
      'soda',
      'champagne',
      'cereal',
      'dog food',
      'ziploc bags',
      'canned soup',
      'canned beans',
      'beans',
      'bread',
      'bagels',
      'muffins',
      'cinnamon rolls',
      'fish sticks',
      'ice cream',
      'pizza',
      'lean cuisine',
      'detergent',
      'dryer sheets',
      'bleach'
    ];

    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

    CollectionReference collectionReferenceReceipts = Firestore.instance
        .collection('users')
        .document(firebaseUser.uid)
        .collection('receipts');

    int num = mockInteger(5, 10);

    List<DateTime> dateTimeList = [];

    for (int i = 0; i < num; i++) {
      dateTimeList.add(mockDate(
          DateTime.now().subtract(Duration(days: 90)), DateTime.now()));
    }

    dateTimeList.sort((a, b) => a.compareTo(b));

    for (int i = 0; i < num; i++) {
      foodList.shuffle();

      int itemCount = mockInteger(5, 10);
      Map<String, int> itemList = Map();

      for (int j = 0; j < itemCount; j++) {
        itemList[foodList[j]] = mockInteger(2, 10);
      }

      Receipt receipt = Receipt(itemList: itemList, timeStamp: dateTimeList[i]);

      await collectionReferenceReceipts
          .add(Receipt.receiptToFireStore(receipt));
    }
  }
}

class ListItem {
  final String item;
  final int days;

  ListItem({@required this.item, @required this.days});
}

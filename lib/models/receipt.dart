import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'receipt.g.dart';

@JsonSerializable()
class Receipt {
  final String id;
  final Map<String, int> itemList;
  final DateTime timeStamp;

  Receipt({this.id, @required this.itemList, @required this.timeStamp});

  static Map<String, dynamic> receiptToFireStore(Receipt instance) =>
      <String, dynamic>{
        'item_ist': instance.itemList,
        'created': Timestamp.fromDate(instance.timeStamp),
      };

  factory Receipt.fromFireStore(DocumentSnapshot doc) {
    return Receipt(
      id: doc.documentID,
      itemList: (doc['item_ist'] as Map<String, dynamic>)?.map(
        (k, e) => MapEntry(k, e as int),
      ),
      timeStamp: doc['created'].toDate(),
    );
  }

  factory Receipt.fromJson(Map<String, dynamic> json) =>
      _$ReceiptFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiptToJson(this);
}

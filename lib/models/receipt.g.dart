// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Receipt _$ReceiptFromJson(Map<String, dynamic> json) {
  return Receipt(
    id: json['id'] as String,
    itemList: (json['itemList'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as int),
    ),
    timeStamp: json['timeStamp'] == null
        ? null
        : DateTime.parse(json['timeStamp'] as String),
  );
}

Map<String, dynamic> _$ReceiptToJson(Receipt instance) => <String, dynamic>{
      'id': instance.id,
      'itemList': instance.itemList,
      'timeStamp': instance.timeStamp?.toIso8601String(),
    };

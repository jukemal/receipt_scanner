import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
	final String id;
	final String userName;
	final String email;
	final String phoneNumber;

	User(
		{this.id,
			@required this.userName,
			@required this.email,
			@required this.phoneNumber,});

	static Map<String, dynamic> userToFireStore(User instance) =>
		<String, dynamic>{
			'userName': instance.userName,
			'email': instance.email,
			'phoneNumber': instance.phoneNumber,
		};

	factory User.fromFireStore(DocumentSnapshot doc) {
		Map<String, dynamic> data = doc.data;

		return User(
			id: doc.documentID,
			userName: data['userName'],
			email: data['email'],
			phoneNumber: data['phoneNumber'],
		);
	}

	factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

	Map<String, dynamic> toJson() => _$UserToJson(this);
}

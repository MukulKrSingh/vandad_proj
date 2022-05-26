//Json Model class
import 'package:flutter/foundation.dart' show immutable;



@immutable
class PersonModel {
  final String name;
  final int age;

  const PersonModel({
    required this.name,
    required this.age,
  });

  PersonModel.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        age = json['age'] as int;

  @override
  String toString() => 'Person (name = $name , age = $age';
}
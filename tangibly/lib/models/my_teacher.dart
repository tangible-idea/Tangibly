import 'package:flutter/cupertino.dart';

class Teacher {
  final String name;
  final Image profileImage;
  const Teacher(this.name, this.profileImage);

  @override
  String toString() => name;
}
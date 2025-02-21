import 'package:flutter/material.dart';

enum StoryAppColors {
  red('Red', Colors.redAccent),
  pink('Pink', Colors.pinkAccent);

  const StoryAppColors(this.name, this.color);

  final String name;
  final Color color;
}

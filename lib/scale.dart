import 'package:flutter/material.dart';

class Scale {
  const Scale({
    required this.index,
    required this.color,
    required this.scale,
  });

  final int index;
  final Color color;
  final String scale;

  Color get pressedColor => color.withOpacity(0.75);
}

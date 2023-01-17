import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  Color getForegroundColor() {
    return (computeLuminance() > 0.179) ? Colors.black : Colors.white;
  }
}

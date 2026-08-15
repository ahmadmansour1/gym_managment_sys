import 'package:flutter/material.dart';

Color parseHexColor(String hex) {
  var value = hex.trim();
  if (value.startsWith('#')) {
    value = value.substring(1);
  }
  if (value.length == 6) {
    value = 'FF$value';
  }
  return Color(int.parse(value, radix: 16));
}

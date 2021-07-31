import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class FontWeightConverter implements JsonConverter<FontWeight, String> {
  const FontWeightConverter();

  @override
  FontWeight fromJson(String json) => Map.fromIterable(
        FontWeight.values,
        key: (e) => e.toString(),
        value: (e) => e,
      )[json];

  @override
  String toJson(FontWeight object) => object.toString();
}

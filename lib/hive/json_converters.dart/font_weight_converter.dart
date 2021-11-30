import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class FontWeightConverter implements JsonConverter<FontWeight, String> {
  const FontWeightConverter();

  @override
  FontWeight fromJson(String json) =>
      {for (var e in FontWeight.values) e.toString(): e}[json]!;

  @override
  String toJson(FontWeight object) => object.toString();
}

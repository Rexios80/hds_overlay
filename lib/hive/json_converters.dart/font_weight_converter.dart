import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class FontWeightConverter implements JsonConverter<FontWeight, String> {
  // TODO: Figure out why FontWeight.toString is broken
  static const weightToString = {
    FontWeight.w100: 'FontWeight.w100',
    FontWeight.w200: 'FontWeight.w200',
    FontWeight.w300: 'FontWeight.w300',
    FontWeight.w400: 'FontWeight.w400',
    FontWeight.w500: 'FontWeight.w500',
    FontWeight.w600: 'FontWeight.w600',
    FontWeight.w700: 'FontWeight.w700',
    FontWeight.w800: 'FontWeight.w800',
    FontWeight.w900: 'FontWeight.w900',
  };

  static final stringToWeight = {
    for (final entry in weightToString.entries) entry.value: entry.key,
  };

  const FontWeightConverter();

  @override
  FontWeight fromJson(String json) => stringToWeight[json]!;

  @override
  String toJson(FontWeight object) => weightToString[object]!;
}

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/hive/tuple2_double.dart';
import 'package:hive/hive.dart';

import 'data_type.dart';

part 'data_widget_properties.g.dart';

@HiveType(typeId: 0)
class DataWidgetProperties extends Rxn with HiveObjectMixin {
  @HiveField(0)
  DataType _dataType = DataType.unknown;

  @HiveField(1)
  bool _showImage = true;

  @HiveField(2)
  Uint8List? _image;

  @HiveField(3)
  double _imageSize = 50;

  @HiveField(4)
  double _fontSize = 28;

  @HiveField(5)
  int _textColor = Colors.white.value;

  @HiveField(6)
  double _textPaddingLeft = 10;

  @HiveField(7)
  String _font = 'Monaco';

  @HiveField(8)
  Tuple2Double _position = Tuple2Double(10, 100);

  @HiveField(9)
  String _unit = '';

  @HiveField(10)
  int _style = 0;

  @HiveField(11)
  bool _textShadow = true;

  @HiveField(12)
  double _textShadowRadius = 8;

  @HiveField(13)
  bool _textStroke = false;

  @HiveField(14)
  double _textStrokeWidth = 1;

  @HiveField(15)
  double _textPaddingTop = 10;

  DataType get dataType => _dataType;

  set dataType(DataType value) {
    _dataType = value;
    _saveAndRefresh();
  }

  double get textPaddingTop => _textPaddingTop;

  set textPaddingTop(double value) {
    _textPaddingTop = value;
    _saveAndRefresh();
  }

  double get textStrokeWidth => _textStrokeWidth;

  set textStrokeWidth(double value) {
    _textStrokeWidth = value;
    _saveAndRefresh();
  }

  bool get textStroke => _textStroke;

  set textStroke(bool value) {
    _textStroke = value;
    _saveAndRefresh();
  }

  double get textShadowRadius => _textShadowRadius;

  set textShadowRadius(double value) {
    _textShadowRadius = value;
    _saveAndRefresh();
  }

  bool get textShadow => _textShadow;

  set textShadow(bool value) {
    _textShadow = value;
    _saveAndRefresh();
  }

  int get style => _style;

  set style(int value) {
    _style = value;
    _saveAndRefresh();
  }

  String get unit => _unit;

  set unit(String value) {
    _unit = value;
    _saveAndRefresh();
  }

  Tuple2Double get position => _position;

  set position(Tuple2Double value) {
    _position = value;
    _saveAndRefresh();
  }

  String get font => _font;

  set font(String value) {
    _font = value;
    _saveAndRefresh();
  }

  double get textPaddingLeft => _textPaddingLeft;

  set textPaddingLeft(double value) {
    _textPaddingLeft = value;
    _saveAndRefresh();
  }

  int get textColor => _textColor;

  set textColor(int value) {
    _textColor = value;
    _saveAndRefresh();
  }

  double get fontSize => _fontSize;

  set fontSize(double value) {
    _fontSize = value;
    _saveAndRefresh();
  }

  double get imageSize => _imageSize;

  set imageSize(double value) {
    _imageSize = value;
    _saveAndRefresh();
  }

  Uint8List? get image => _image;

  set image(Uint8List? value) {
    _image = value;
    _saveAndRefresh();
  }

  bool get showImage => _showImage;

  set showImage(bool value) {
    _showImage = value;
    _saveAndRefresh();
  }

  void _saveAndRefresh() {
    try {
      save();
      refresh();
    } catch (error) {
      // This can get called before the object is actually in the box
    }
  }
}

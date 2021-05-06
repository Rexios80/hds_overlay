import 'package:get/get.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/model/log_message.dart';
import 'package:hds_overlay/model/message.dart';
import 'package:tuple/tuple.dart';

abstract class ConnectionController extends GetxController {
  final messages = Map<Tuple2<DataType, String>, DataMessage>().obs;
  final logs = <LogMessage>[].obs;

  void start();
  void stop();
}
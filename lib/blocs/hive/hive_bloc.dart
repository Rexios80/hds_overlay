import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hds_overlay/hive/hive_utils.dart';

// This class is just used to share the hive instance with the views. It doesn't actually do anything.
class HiveBloc extends Bloc {
  final HiveUtils hive;

  HiveBloc(this.hive) : super(null);

  @override
  Stream mapEventToState(event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }
}

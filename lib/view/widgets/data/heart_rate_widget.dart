import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/controllers/heart_rate_widget_controller.dart';
import 'package:hds_overlay/controllers/socket_server_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/utils/audio_source_macos.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

import 'data_widget.dart';

class HeartRateWidget extends DataWidgetBase {
  HeartRateWidget() : super.withWidgets(HeartRateImage(), HeartRateText());
}

class HeartRateImage extends HookWidget {
  final DataWidgetController dwc = Get.find();
  final HeartRateWidgetController hrwc = Get.put(HeartRateWidgetController())
    ..animating = false;
  final SocketServerController socketServerController = Get.find();

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(initialValue: 1.0);
    useAnimation(controller);

    final properties =
        dwc.propertiesMap[DataType.heartRate] ?? DataWidgetProperties().obs;

    ever(
        socketServerController.messages,
        (_) => hrwc.currentHeartRate = int.tryParse(
                socketServerController.messages[DataType.heartRate]?.value ??
                    '') ??
            0);

    ever(properties, (_) {
      if (properties.value.animated && !hrwc.animating) {
        animateImage(controller);
      }
      hrwc.animating = properties.value.animated;

      if (properties.value.heartBeatSound != null && !hrwc.sounding) {
        playBeatSound(properties);
      }
      hrwc.sounding = properties.value.heartBeatSound != null;
    });

    if (properties.value.animated && !hrwc.animating) {
      animateImage(controller);
    }

    if (properties.value.heartBeatSound != null && !hrwc.sounding) {
      playBeatSound(properties);
    }

    return Obx(() {
      if (properties.value.showImage) {
        return SizedBox(
          height: properties.value.imageSize,
          width: properties.value.imageSize,
          child: Center(
            child: SizedBox(
              height: properties.value.imageSize * controller.value,
              width: properties.value.imageSize * controller.value,
              child: DataWidgetImage(square: true),
            ),
          ),
        );
      } else {
        return SizedBox.shrink();
      }
    });
  }

  void animateImage(AnimationController controller) async {
    hrwc.animating = true;

    while (hrwc.animating) {
      if (hrwc.currentHeartRate == 0) {
        await Future.delayed(Duration(milliseconds: 100));
        continue;
      }
      final int millisecondsPerBeat =
          (60 / hrwc.currentHeartRate * 1000).toInt();

      try {
        await controller.animateTo(0.85,
            duration:
            Duration(milliseconds: (millisecondsPerBeat * (3 / 4)).toInt()));
        await controller.animateTo(1.0,
            duration:
            Duration(milliseconds: (millisecondsPerBeat * (1 / 4)).toInt()));
      } catch (error) {
        // The controller is disposed
        return;
      }
    }
  }

  void playBeatSound(Rx<DataWidgetProperties> properties) async {
    if (properties.value.heartBeatSound == null) return;

    hrwc.sounding = true;

    final soundBytes = properties.value.heartBeatSound!;
    final player;
    if (Platform.isMacOS) {
      player = AudioPlayer();
      player.setAudioSource(MacosAudioSource(soundBytes));
    } else {
      player = await Player.create(id: 69420);
      await player.open(await Media.file(File(
          (await getApplicationDocumentsDirectory()).path +
              '\\Health Data Server\\beatSound.mp3')
        ..writeAsBytesSync(soundBytes)));
    }
    while (hrwc.sounding) {
      final startTime = DateTime.now().millisecondsSinceEpoch;
      if (hrwc.currentHeartRate == 0) {
        await Future.delayed(Duration(milliseconds: 100));
        continue;
      }

      final int millisecondsPerBeat =
          (60 / hrwc.currentHeartRate * 1000).toInt();

      if (Platform.isMacOS) {
        player.seek(Duration(seconds: 0));
        player.play();
      } else {
        await player.play();
      }

      final endTime = DateTime.now().millisecondsSinceEpoch;
      final duration = endTime - startTime;
      await Future.delayed(
          Duration(milliseconds: millisecondsPerBeat - duration));
    }
  }
}

class HeartRateText extends DataWidgetText {
  final HeartRateWidgetController hrwc = Get.find();

  @override
  Color getTextColor(Rx<DataWidgetProperties> properties) {
    final ranges = properties.value.heartRateRanges.entries.toList();
    ranges.sort((a, b) => a.key.compareTo(b.key));
    return Color(
      ranges.reversed
          .firstWhere((e) => hrwc.currentHeartRate >= e.key,
              orElse: () => MapEntry(0, Colors.white.value))
          .value,
    );
  }
}

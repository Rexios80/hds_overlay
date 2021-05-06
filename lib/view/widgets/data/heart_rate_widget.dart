import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/connection_controller.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/controllers/heart_rate_widget_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/model/message.dart';
import 'package:hds_overlay/utils/audio_source_macos.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'data_widget.dart';

class HeartRateWidget extends DataWidgetBase {
  HeartRateWidget() : super.withWidgets(HeartRateImage(), HeartRateText());

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => HeartRateWidgetController(),
      child: super.build(context),
    );
  }
}

class HeartRateImage extends HookWidget {
  final DataWidgetController dwc = Get.find();
  final ConnectionController connectionController = Get.find();

  @override
  Widget build(BuildContext context) {
    final hrwc = Provider.of<HeartRateWidgetController>(context);
    final typeSource = Provider.of<Tuple2<DataType, String>>(context);

    final controller = useAnimationController(initialValue: 1.0);
    useAnimation(controller);

    final properties =
        dwc.propertiesMap[typeSource] ?? DataWidgetProperties().obs;

    ever(connectionController.messages,
        (Map<Tuple2<DataType, String>, DataMessage> messages) {
      hrwc.currentHeartRate =
          int.tryParse(messages[typeSource]?.value ?? '') ?? 0;
    });

    ever(properties, (_) {
      if (properties.value.animated && !hrwc.animating) {
        animateImage(controller, hrwc);
      }
      hrwc.animating = properties.value.animated;

      if (properties.value.heartBeatSound != null && !hrwc.sounding) {
        playBeatSound(properties, hrwc);
      }
      hrwc.sounding = properties.value.heartBeatSound != null;
    });

    if (properties.value.animated && !hrwc.animating) {
      animateImage(controller, hrwc);
    }

    if (properties.value.heartBeatSound != null && !hrwc.sounding) {
      playBeatSound(properties, hrwc);
    }

    return LifecycleWrapper(
      onLifecycleEvent: (LifecycleEvent event) {
        if (event == LifecycleEvent.invisible) {
          hrwc.visible = false;
        }
      },
      child: Obx(
        () => Visibility(
          visible: properties.value.showImage,
          child: SizedBox(
            height: properties.value.imageSize,
            width: properties.value.imageSize,
            child: Center(
              child: SizedBox(
                height: properties.value.imageSize * controller.value,
                width: properties.value.imageSize * controller.value,
                child: DataWidgetImage(square: true),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void animateImage(
      AnimationController controller, HeartRateWidgetController hrwc) async {
    hrwc.animating = true;

    while (hrwc.animating && hrwc.visible) {
      if (hrwc.currentHeartRate == 0) {
        await Future.delayed(Duration(milliseconds: 100));
        continue;
      }
      final int millisecondsPerBeat =
          (60 / hrwc.currentHeartRate * 1000).toInt();

      try {
        await controller.animateTo(0.85,
            duration: Duration(
                milliseconds: (millisecondsPerBeat * (3 / 4)).toInt()));
        await controller.animateTo(1.0,
            duration: Duration(
                milliseconds: (millisecondsPerBeat * (1 / 4)).toInt()));
      } catch (error) {
        // The controller is disposed
        return;
      }
    }
  }

  void playBeatSound(Rx<DataWidgetProperties> properties,
      HeartRateWidgetController hrwc) async {
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
    while (hrwc.sounding && hrwc.visible) {
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
  @override
  Color getTextColor(
      Rx<DataWidgetProperties> properties, BuildContext context) {
    final hrwc = Provider.of<HeartRateWidgetController>(context);

    final ranges = properties.value.heartRateRanges.entries.toList();
    ranges.sort((a, b) => a.key.compareTo(b.key));
    return Color(
      ranges.reversed
          .firstWhere((e) => hrwc.currentHeartRate >= e.key,
              orElse: () => MapEntry(0, properties.value.textColor))
          .value,
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/connection_controller.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/controllers/heart_rate_widget_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/model/message.dart';
import 'package:hds_overlay/utils/audio_source_web.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'data_widget.dart';

class HeartRateWidget extends DataWidgetBase {
  HeartRateWidget()
      : super.withWidgets(HeartRateImageAnimated(), HeartRateText());

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => HeartRateWidgetController(),
      child: super.build(context),
    );
  }
}

class HeartRateImageAnimated extends HookWidget {
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
                child: HeartRateImage(square: true),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void animateImage(
    AnimationController controller,
    HeartRateWidgetController hrwc,
  ) async {
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

  void playBeatSound(
    Rx<DataWidgetProperties> properties,
    HeartRateWidgetController hrwc,
  ) async {
    if (properties.value.heartBeatSound == null || !kIsWeb) return;

    hrwc.sounding = true;

    final soundBytes = properties.value.heartBeatSound!;
    final player = AudioPlayer();
    player.setAudioSource(WebAudioSource(soundBytes));

    while (hrwc.sounding && hrwc.visible) {
      final startTime = DateTime.now().millisecondsSinceEpoch;
      if (hrwc.currentHeartRate == 0 ||
          hrwc.currentHeartRate < properties.value.heartBeatSoundThreshold) {
        player.stop();
        await Future.delayed(Duration(milliseconds: 100));
        continue;
      } else {
        player.play();
      }

      final int millisecondsPerBeat =
          (60 / hrwc.currentHeartRate * 1000).toInt();

      player.seek(Duration(seconds: 0));

      final endTime = DateTime.now().millisecondsSinceEpoch;
      final duration = endTime - startTime;
      await Future.delayed(
        Duration(milliseconds: millisecondsPerBeat - duration),
      );
    }
  }
}

class HeartRateImage extends DataWidgetImage {
  HeartRateImage({bool square = false}) : super(square: square);

  @override
  Color? getImageColor(
    Rx<DataWidgetProperties> properties,
    BuildContext context,
  ) =>
      properties.value.colorImage
          ? _createRangeColor(
              properties,
              context,
              fallback: properties.value.imageColor,
            )
          : null;
}

class HeartRateText extends DataWidgetText {
  @override
  Color getTextColor(
    Rx<DataWidgetProperties> properties,
    BuildContext context,
  ) =>
      _createRangeColor(
        properties,
        context,
        fallback: Color(properties.value.textColor),
      );
}

Color _createRangeColor(
  Rx<DataWidgetProperties> properties,
  BuildContext context, {
  required Color fallback,
}) {
  final hrwc = Provider.of<HeartRateWidgetController>(context);

  final ranges = properties.value.heartRateRanges.entries.toList();
  ranges.sort((a, b) => a.key.compareTo(b.key));
  return Color(
    ranges.reversed
        .firstWhere((e) => hrwc.currentHeartRate >= e.key,
            orElse: () => MapEntry(0, fallback.value))
        .value,
  );
}

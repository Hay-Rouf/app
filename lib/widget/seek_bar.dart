import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../export.dart';


class SeekBar extends GetView<AppController> {
  const SeekBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Duration? a;
    // Duration? b;
    double sliderValue = 0.0;
    return StreamBuilder<PositionData>(
        stream: controller.positionDataStream,
        builder: (context, snapshot) {
          final positionData = snapshot.data;
          Duration duration =
              positionData?.duration ?? controller.defaultDuration;
          Duration position = positionData?.position ?? Duration.zero;
          sliderValue = min(position.inMilliseconds.toDouble(),
              duration.inMilliseconds.toDouble());
          return Column(
            children: [
              SizedBox(
                height: 10,
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: myWhite,
                    trackHeight: 3,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 5),
                    thumbColor: myWhite,
                    inactiveTrackColor: myWhite.withOpacity(.2),
                  ),
                  child: Slider(
                    min: 0.0,
                    max: duration.inMilliseconds.toDouble(),
                    value: sliderValue,
                    onChanged: (value) {
                      controller.seekAudio(Duration(milliseconds: value.round()));
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        controller.formatTime(
                            position < duration ? position : Duration.zero),
                        style: TextStyle(color: myWhite, fontSize: 10),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        controller.formatTime(duration),
                        textAlign: TextAlign.end,
                        style: TextStyle(color: myWhite, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }
}

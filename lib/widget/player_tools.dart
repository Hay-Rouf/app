import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../export.dart';


class PlayerTools extends GetView<AppController> {
  const PlayerTools({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double iconSize = MediaQuery.of(context).size.width * 0.1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Obx(() {
        //   return IconButton(
        //     onPressed: constantsController.changeLoop,
        //     icon: repeatButton(constantsController.loop.value),
        //   );
        // }),
        GestureDetector(
          onTap: controller.changeLoop,
          child: StreamBuilder(
              stream: controller.loop.stream,
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  Loop loopChecker = snapshot.data!;
                  switch (loopChecker) {
                    case Loop.all:
                      return Icon(
                        Icons.repeat,
                        color: myWhite,
                        size: iconSize,
                      );
                    case Loop.one:
                      return Icon(
                        Icons.repeat_one,
                        color: myWhite,
                        size: iconSize,
                      );
                    case Loop.off:
                      return Icon(
                        Icons.repeat_on_sharp,
                        color: myWhite,
                        size: iconSize,
                      );
                  }
                }
                return const Icon(
                  Icons.repeat,
                  color: myWhite,
                );
              }),
        ),
        IconButton(
            onPressed: controller.skipToPrevious,
            icon: Icon(
              Icons.skip_previous,
              size: iconSize,
              color: myWhite,
            )),
        StreamBuilder<PlayerState>(
          stream: controller.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                //padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: myWhite.withOpacity(.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const SpinKitRipple(
                  color: myWhite,
                ),
              );
            } else if (playing == false) {
              return InkWell(
                onTap: controller.play,
                child: CircleAvatar(
                  backgroundColor: myWhite.withOpacity(.3),
                  radius: iconSize * .8,
                  child: Icon(
                    Icons.play_arrow,
                    color: myWhite,
                    size: iconSize,
                  ),
                ),
              );
            } else if (processingState == ProcessingState.completed) {
              return InkWell(
                onTap: () => controller.seekAudio(Duration.zero),
                child: CircleAvatar(
                  backgroundColor: myWhite.withOpacity(.3),
                  radius: iconSize * .8,
                  child: Icon(
                    Icons.play_arrow,
                    size: iconSize,
                    color: myWhite,
                  ),
                ),
              );
            } else {
              return InkWell(
                onTap: controller.pause,
                child: CircleAvatar(
                  backgroundColor: myWhite.withOpacity(.3),
                  radius: iconSize * .8,
                  child: Icon(
                    Icons.pause,
                    size: iconSize,
                    color: myWhite,
                  ),
                ),
              );
            }
          },
        ),
        IconButton(
          onPressed: controller.skipToNext,
          icon: Icon(
            Icons.skip_next,
            size: iconSize,
            color: myWhite,
          ),
        ),
        StreamBuilder<double>(
          stream: controller.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Icon(
              Icons.speed,
              color: myWhite,
              size: iconSize,
            ),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                // divisions: 10,
                min: 0.5,
                max: 1.5,
                value: controller.speed,
                stream: controller.speedStream,
                onChanged: controller.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}

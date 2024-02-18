import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_share/social_share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../export.dart';

String appName = '';

getPermission() async {
  if (!(await Permission.storage.isGranted)) {
    Permission.storage.request();
  }
}

findAppName() async {
  Map json = await jsonDecode(await rootBundle.loadString(assetJson));
  appName = json['reciter'];
  appLink = json['appLink'];
}

const String moreApps =
    'https://play.google.com/store/apps/developer?id=AROUF+TECHNOLOGIES+LTD';
const String facebookId = '1033302077868192';
const String privacyLink = 'https://266093.hostmypolicy.com/';
String appLink = '';
String appWords = """Discover the serenity of the Quran with our app! 📖✨
🌟 Immerse yourself in the divine wisdom of the Quran, now at your fingertips. Our app provides a seamless and enriching experience, making it easier than ever to connect with the sacred verses.

📚 Features:
✨ Read the Quran in clear and elegant Arabic script
✨ Translations in multiple languages for a profound understanding
✨ Verse-by-verse audio recitations by renowned Qaris
✨ Bookmark and highlight your favorite verses
✨ Daily reminders for your spiritual journey
✨ Search functionality for easy navigation

Whether you're a seasoned scholar or a curious soul seeking solace, our app is designed to enhance your relationship with the Quran. Download now and embark on a journey of spiritual enlightenment! 🌙📱 #QuranApp #SpiritualJourney #DivineWisdom""";


Future<void> shareApp() async {
  await SocialShare.shareOptions('$appWords\n$appLink');
}

Future<void> rateApp(uri) async {
  final Uri url = Uri.parse(uri);
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}

// floater() {
//   return Obx(() {
//     return StreamBuilder<PlayerState>(
//       stream: appController.playerStateStream,
//       builder: (context, snapshot) {
//         final playerState = snapshot.data;
//         final processingState = playerState?.processingState;
//         final playing = playerState?.playing;
//         if (processingState == ProcessingState.loading ||
//             processingState == ProcessingState.buffering) {
//           return FloatingActionButton(
//             backgroundColor: myBlue,
//             onPressed: () {
//               Get.toNamed(PlayerScreen.id);
//             },
//             child: Stack(
//               alignment: Alignment.center,
//               children: const [
//                 SpinKitRipple(
//                   color: myWhite,
//                   duration: Duration(seconds: 3),
//                 ),
//                 Icon(
//                   CupertinoIcons.music_note_2,
//                   color: myWhite,
//                 ),
//               ],
//             ),
//           );
//         } else if (playing == false) {
//           return FloatingActionButton(
//             backgroundColor: myBlue,
//             onPressed: () {
//               Get.toNamed(PlayerScreen.id);
//             },
//             child: const Icon(
//               CupertinoIcons.music_note_2,
//               color: myWhite,
//             ),
//           );
//         } else if (processingState == ProcessingState.completed) {
//           return FloatingActionButton(
//             backgroundColor: myBlue,
//             onPressed: () {
//               Get.toNamed(PlayerScreen.id);
//             },
//             child: const Icon(
//               CupertinoIcons.music_note_2,
//               color: myWhite,
//             ),
//           );
//         } else if (playing == true) {
//           return FloatingActionButton(
//             backgroundColor: myBlue,
//             onPressed: () {
//               Get.toNamed(PlayerScreen.id);
//             },
//             child: Stack(
//               alignment: Alignment.center,
//               children: const [
//                 SpinKitRipple(
//                   color: myWhite,
//                   duration: Duration(seconds: 3),
//                 ),
//                 Icon(
//                   CupertinoIcons.music_note_2,
//                   color: myWhite,
//                 ),
//               ],
//             ),
//           );
//         }
//         return Container();
//       },
//     );
//   });
// }

class Floater extends GetView<AppController> {
  const Floater({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: controller.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        print('processingState: $processingState, playing: $playing');
        if (processingState == ProcessingState.ready && playing == false) {
          return FloatingActionButton(
            backgroundColor: myBlue,
            onPressed: () {
              Get.toNamed(PlayerScreen.id);
            },
            child: const Icon(
              CupertinoIcons.music_note_2,
              color: myWhite,
            ),
          );
        } else if (processingState == ProcessingState.ready &&
            playing == true) {
          return FloatingActionButton(
            backgroundColor: myBlue,
            onPressed: () {
              Get.toNamed(PlayerScreen.id);
            },
            child: const Stack(
              alignment: Alignment.center,
              children: [
                SpinKitRipple(
                  color: myWhite,
                  duration: Duration(seconds: 3),
                ),
                Icon(
                  CupertinoIcons.music_note_2,
                  color: myWhite,
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

void showDownloadDialog({
  required BuildContext context,
  required String title,
  VoidCallback? listen,
  VoidCallback? download,
  String? content,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: Text(content ?? ''),
      actions: [
        TextButton(
          onPressed: listen,
          child: const Text('Play'),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * .2,
        ),
        TextButton(
          onPressed: download,
          child: const Text('Download'),
        ),
      ],
    ),
  );
}

void showSliderDialog({
  required BuildContext context,
  required String title,
  required double min,
  required double max,
  String valueSuffix = '',
  required double value,
  required Stream<double> stream,
  required ValueChanged<double> onChanged,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => SizedBox(
          height: 100.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: const TextStyle(
                      fontFamily: 'Fixed',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0)),
              Slider(
                min: min,
                max: max,
                value: snapshot.data ?? value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../export.dart';

class PlayerScreen extends GetView<AppController> {
  const PlayerScreen({Key? key}) : super(key: key);
  static const String id = '/playerScreen';

  @override
  Widget build(BuildContext context) {
    // print('native: ${adManager.nativeAd != null}');

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: const BannerWidget(),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios,color: myWhite,),
            onPressed: () {
              Get.back();
            },
          ),
          title: controller.playOnline.value
              ? Obx(() => Text(
                    controller.onlineTitle.value,
                    style: const TextStyle(fontSize: 20, color: myWhite),
                  ))
              : StreamBuilder(
                  stream: controller.currentIndexStream,
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      int index = snapshot.data!;
                      return Text(
                        controller.details[index]['title']!,
                        style: const TextStyle(fontSize: 20, color: myWhite),
                      );
                    }
                    return const Center(
                        child: CircularProgressIndicator(
                      color: myBlue,
                    ));
                  }),
          centerTitle: true,
          actions: const [
            IconButton(onPressed: shareApp, icon: Icon(Icons.share,color: myWhite,)),
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(assetImage, fit: BoxFit.cover),
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.black.withOpacity(.4),
                  alignment: Alignment.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    child: Image.asset(
                      assetImage,
                      height: MediaQuery.of(context).size.height * .45,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  controller.playOnline.value
                      ? Obx(() => Text(
                            controller.onlineTitleAr.value,
                            style:
                                const TextStyle(fontSize: 20, color: myWhite),
                          ))
                      : StreamBuilder(
                          stream: controller.currentIndexStream,
                          builder: (_, snapshot) {
                            if (snapshot.hasData) {
                              int index = snapshot.data!;
                              return Text(
                                controller.details[index]['titleAr']!
                                    .split('.')
                                    .first,
                                style: const TextStyle(
                                    fontSize: 20, color: myWhite),
                              );
                            }
                            return const Center(
                                child: CircularProgressIndicator(
                              color: myBlue,
                            ));
                          }),
                  const SizedBox(height: 10),
                  const SeekBar(),
                  const SizedBox(height: 10),
                  const PlayerTools(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// NativeAdWidget(
//   customWidget: Image.asset(
//     assetImage,
//     height: MediaQuery.of(context).size.height * .45,
//     fit: BoxFit.cover,
//   ),
// ),
// GetX<AdManager>(
//   initState: (_) {
//     _.controller?.loadNativeAds(AdUnits.NativeAdvanced);
//   },
//   builder: (logic) {
//     return adManager.nativeAd != null
//         ? ConstrainedBox(
//             constraints: const BoxConstraints(
//               minWidth: 320,
//               minHeight: 320,
//               maxWidth: 400,
//               maxHeight: 400,
//             ),
//             child: AdWidget(ad: adManager.nativeAd!.value),
//           )
//         : Image.asset(
//             assetImage,
//             height:
//                 MediaQuery.of(context).size.height * .45,
//             fit: BoxFit.cover,
//           );
//   },
// ),

// Obx(() {
//   // print(controller.player.currentIndex);
//   return Text(
//     controller.details[controller.player.currentIndex!]['title']!,
//     style: TextStyle(fontSize: 20, color: myWhite),
//   );
// }),

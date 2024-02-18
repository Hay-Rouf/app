import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../export.dart';

class DownLoadsScreen extends GetView<DownloadsController> {
  const DownLoadsScreen({Key? key}) : super(key: key);
  static const String id = '/downLoadsScreen';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: const BannerWidget(),
      floatingActionButton: const Floater(),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios),color: myWhite,),
        backgroundColor: myBlue,
        title: const Text(
          'Downloads',
          style: TextStyle(color: myWhite),
        ),
      ),
      body: Obx(() {
        return GridView.builder(
          itemCount: controller.downloadItems.length,
          itemBuilder: (_, index) {
            String rawItem = controller.downloadItems[index];
            String item = controller.downloadItems[index]
                .split('/')
                .last
                .replaceAll('.mp3', '');
            return GestureDetector(
              onTap: () {
                print(rawItem);
                controller.appController.setChildren(rawItem);
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                // padding: const EdgeInsets.all(10),
                height: size.height * .2,
                width: size.width * .5,
                decoration: BoxDecoration(
                    color: myWhite,
                    border: Border.all(
                      color: Colors.black,
                    ),
                    image: DecorationImage(image: AssetImage(assetImage),fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(20)),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: myBlack.withOpacity(.5),
                    )),
                    Positioned(
                      top: 12,
                      left: 15,
                      child: Text(
                        item,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Positioned(
                      top: 18,
                      right: 15,
                      child: GestureDetector(
                          onTap: () {
                            print('tap');
                            controller.appController.deleteFile(rawItem);
                            controller.itemsSpeaker();
                          },
                          child: const Icon(
                            Icons.delete,
                            color: myRed,
                            size: 16,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.appController
                                  .getOtherInfo(int.parse(item))
                                  .englishName,
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              controller.appController
                                  .getOtherInfo(int.parse(item))
                                  .name,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
        );
      }),
    );
  }
}

class DownloadsController extends GetxController {
  @override
  void onInit() {
    itemsSpeaker();
    super.onInit();
  }

  itemsSpeaker() {
    downloadItems.value = getDownloaded();
  }

  final AppController appController = Get.find();

  RxList downloadItems = [].obs;

  List<String> getDownloaded() {
    List<String> downloadedFiles = [];
    try {
      List<FileSystemEntity> files = appController.dir.listSync();
      for (var element in files) {
        element.path.split('/').last.contains('-')
            ? null
            : downloadedFiles.add(element.path);
      }
    } catch (e) {
      print(e);
    }
    downloadedFiles.sort((a, b) => a
        .split('/')
        .last
        .split('_')
        .first
        .compareTo(b.split('/').last.split('_').first));
    return downloadedFiles;
  }
}

class DownloadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DownloadsController());
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../export.dart';

class SurahListScreen extends GetView<AppController> {
  const SurahListScreen({Key? key}) : super(key: key);
  static const String id = '/SurahListScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      drawerDragStartBehavior: DragStartBehavior.down,
      drawerEnableOpenDragGesture: true,
      bottomNavigationBar: const BannerWidget(),
      floatingActionButton: const Floater(),
      appBar: AppBar(
        //   leading: IconButton(icon:Icon(Icons.menu),onPressed: (){
        //     MyDrawer();
        // },color: myWhite,),
        iconTheme: const IconThemeData(color: myWhite),
        backgroundColor: myBlue,
        title: const Text(
          'Al Quran',
          style: TextStyle(
            color: myWhite,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await showSearch<String>(
                context: context,
                delegate: CustomDelegate(),
              );
            },
            icon: const Icon(
              Icons.search,
              color: myWhite,
            ),
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: controller.surahs.length,
          itemBuilder: (_, index) {
            SurahModel dataItem = controller.surahs[index];
            return MyListTile(
              dataItem: dataItem,
            );
          }),
    );
  }
}

class MyListTile extends StatefulWidget {
  const MyListTile({
    Key? key,
    required this.dataItem,
  }) : super(key: key);

  final SurahModel dataItem;

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  // bool tap = false;
  final AppController controller = Get.find<AppController>();

  String fileName = '';

  @override
  void initState() {
    fileName = '${widget.dataItem.number}';
    checkFav();
    // loadInterstitialAd();
    super.initState();
  }

  // InterstitialAd? interstitialAd;

  // Future<void> loadInterstitialAd() async {
  //   await InterstitialAd.load(
  //       adUnitId: AdUnits.interstitial,
  //       request: const AdRequest(),
  //       adLoadCallback: InterstitialAdLoadCallback(
  //         // Called when an ad is successfully received.
  //         onAdLoaded: (ad) {
  //           // controller.snackBar('ads', txt1: 'ads loaded');
  //           ad.fullScreenContentCallback = FullScreenContentCallback(
  //               // Called when the ad showed the full screen content.
  //               onAdShowedFullScreenContent: (ad) {},
  //               // Called when an impression occurs on the ad.
  //               onAdImpression: (ad) {},
  //               // Called when the ad failed to show full screen content.
  //               onAdFailedToShowFullScreenContent: (ad, err) {
  //                 // Dispose the ad here to free resources.
  //                 ad.dispose();
  //               },
  //               // Called when the ad dismissed full screen content.
  //               onAdDismissedFullScreenContent: (ad) {
  //                 // Dispose the ad here to free resources.
  //                 ad.dispose();
  //               },
  //               // Called when a click is recorded for an ad.
  //               onAdClicked: (ad) {});
  //
  //           debugPrint('$ad loaded.');
  //           // Keep a reference to the ad so you can show it later.
  //           interstitialAd = ad;
  //         },
  //         // Called when an ad request failed.
  //         onAdFailedToLoad: (LoadAdError error) {
  //           debugPrint('InterstitialAd failed to load: $error');
  //         },
  //       ));
  // }

  double? downloaded;
  bool downloading = false;

  Future<void> downloader() async {
    getPermission();
    String path = '${controller.fileFolder}$fileName.mp3';
    setState(() {
      downloading = true;
    });
    controller.snackBar('Please wait');
    // Dio dio = Dio();
    File? result;

    if (!(await File('${controller.dir.path}$fileName.mp3').exists())) {
      print('download');
      result = await FileDownloader.downloadFile(
          url: widget.dataItem.url,
          name: path,
          downloadDestination: DownloadDestinations.publicDownloads,
          onProgress: (String? fileName, double progress) {
            print('FILE $fileName HAS PROGRESS $progress');
            setState(() {
              downloaded = progress;
            });
          },
          onDownloadCompleted: (String path) async {
            await adManager.showAd(AdUnits.rewardedVideoAdPlacementId);
            print(path);
            downloading = false;
            controller.snackBar('File Downloaded',
                txt1: '${widget.dataItem.englishName} is downloaded');
            setState(() {});
          },
          onDownloadError: (String error) async {
            errorCall();
          });

      // await dio.download(
      //   widget.dataItem.url,
      //   path,
      //   onReceiveProgress: (rec, all) {
      //     setState(() {
      //       downloaded = (rec / all);
      //     });
      //     if (downloaded == 1.0) {
      //       setState(() {
      //         downloading = false;
      //         controller.snackBar('File Downloaded',
      //             txt1: '${widget.dataItem.englishName} is downloaded');
      //       });
      //     }
      //   },
      // ).onError((error, stackTrace) => errorCall());
    } else {
      setState(() {
        downloading = false;
        // controller.snackBar('Success',
        //     txt1: '${widget.dataItem.englishName} has been deleted');
      });
      controller.deleteFile(controller.dir.path + path);
    }
    print('file ${result!.path} exists: ${await File(result.path).exists()}');
    setState(() {});
  }

  errorCall() {
    downloading = false;
    downloaded = null;
    controller.snackBar('Error', txt1: 'Check Internet Connection');
    setState(() {});
  }

  bool favSurah = false;

  checkFav() {
    List<String> favourite = controller.readFavourites();
    String value = json.encode(widget.dataItem.toMap());
    favSurah = favourite.contains(value);
  }

  writeFavourites() async {
    List<String> favourite = controller.readFavourites();
    String value = json.encode(widget.dataItem.toMap());
    String fav = favSurah ? 'Removed from' : 'Added to';
    favSurah ? favourite.remove(value) : favourite.add(value);
    favSurah = favourite.contains(value);
    await controller.box.write('fav', favourite);
    await preferences.setStringList('fav', favourite);
    // print('fav: $favourite\ncon: ${favourite.contains(value)}');
    controller.snackBar('Success',
        txt1: '${widget.dataItem.englishName} $fav Favourites');
    setState(() {});
  }

  bool getDownloaded(String file) {
    getPermission();
    List<String> downloadedFiles = [];
    try {
      List<FileSystemEntity> files = appController.dir.listSync();
      for (var element in files) {
        element.path.split('/').last.contains('-')
            ? null
            : downloadedFiles.add(element.path);
      }
    } catch (e) {
      print('e: $e');
    }
    downloadedFiles.sort((a, b) => a
        .split('/')
        .last
        .split('_')
        .first
        .compareTo(b.split('/').last.split('_').first));
    return downloadedFiles.contains(file);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // print('${controller.dir.path}$fileName.mp3');
        getDownloaded('${controller.dir.path}$fileName.mp3')
            ? controller.setChildren(
                '${controller.dir.path}$fileName.mp3',
              )
            : showDownloadDialog(
                context: context,
                content: 'Did you wish to play it online or download',
                title: '${widget.dataItem.englishName} has no been Downloaded',
                listen: () {
                  // adManager.showAppOpenAdIfAvailable();
                  Get.back();
                  controller.setOnlineSource(
                    url: widget.dataItem.url,
                    name: widget.dataItem.englishName,
                    id: widget.dataItem.name,
                  );
                },
                download: () async {
                  Get.back();
                  await downloader();
                  // adManager.showInterstitialAd();
                });
      },
      child: Container(
          color: myWhite,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: myBlue,
                      radius: 15,
                      child: Text(
                        widget.dataItem.number.toString(),
                        style: const TextStyle(
                          // fontSize: 20,
                          color: myWhite,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.dataItem.englishName,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          // textAlign: TextAlign.start,
                        ),
                        Text(
                          widget.dataItem.englishNameTranslation,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                          // textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      widget.dataItem.name,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: PopupMenuButton(
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem(
                              onTap: writeFavourites,
                              child: Text(
                                  '${favSurah ? 'Remove from' : 'Add to'} Favorites'),
                            ),
                            PopupMenuItem(
                              onTap: downloader,
                              child: FutureBuilder<bool>(
                                  future: File(
                                          '${controller.dir.path}$fileName.mp3')
                                      .exists(),
                                  builder: (context, snapshot) {
                                    print(
                                        '${controller.dir.path}$fileName.mp3');
                                    return Text(
                                      snapshot.hasData && snapshot.data!
                                          ? 'Delete'
                                          : 'Offline Downloads',
                                    );
                                  }),
                            ),
                            const PopupMenuItem(
                              onTap: shareApp,
                              child: Text('Share'),
                            ),
                          ];
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Builder(builder: (_) {
                    return downloading
                        ? LinearProgressIndicator(
                            color: myBlue,
                            value: downloaded,
                          )
                        : Container();
                  }),
                  const Divider(
                    color: Colors.black,
                  ),
                ],
              ),
            ],
          )),
    );
  }
}

// Text(
//   '  ${widget.dataItem.numberOfAyahs} (${widget.dataItem.revelationType})',
//   style: const TextStyle(
//     fontSize: 15,
//   ),
// ),

// class Tile extends StatelessWidget {
//   const Tile({
//     super.key,
//     required this.dataItem,
//     required this.controller,
//   });
//
//   final SurahModel dataItem;
//   final SudaisController controller;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         color: myWhite,
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                   vertical: 4, horizontal: 10),
//               child: Row(
//                 mainAxisAlignment:
//                     MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     dataItem.number.toString(),
//                     style: const TextStyle(
//                       fontSize: 20,
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 10,
//                   ),
//                   Column(
//                     children: [
//                       Text(
//                         dataItem.englishName,
//                         style: const TextStyle(
//                           fontSize: 20,
//                         ),
//                       ),
//                       Text(
//                         dataItem.englishNameTranslation,
//                         style: const TextStyle(
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Text(
//                     '  ${dataItem.numberOfAyahs} (${dataItem.revelationType})',
//                     style: const TextStyle(
//                       fontSize: 15,
//                     ),
//                   ),
//                   const Spacer(),
//                   Text(
//                     dataItem.name,
//                     style: const TextStyle(
//                       fontSize: 20,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Obx(() {
//               return LinearProgressIndicator(
//                 color: myBlue,
//                 value: controller.downloaded.value/100,
//               );
//             }),
//             const Divider(
//               color: Colors.black,
//             ),
//           ],
//         ));
//   }
// }

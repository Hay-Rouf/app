import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../export.dart';

class FavouriteScreen extends GetView<FavouriteController> {
  const FavouriteScreen({Key? key}) : super(key: key);
  static const String id = '/favScreen';

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: const BannerWidget(),
      floatingActionButton: const Floater(),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios,color: myWhite,)),
        backgroundColor: myBlue,
        title: const Text(
          'Favourites',
          style: TextStyle(color: myWhite),
        ),
      ),
      body: Obx(() {
        List<SurahModel> dataItems = [];
        for (var element in controller.favItems) {
          dataItems.add(SurahModel.fromJson(jsonDecode(element)));
        }
        dataItems.sort((a, b) => a.number.compareTo(b.number));
        return ListView.builder(
            itemCount: dataItems.length,
            itemBuilder: (_, index) {
              SurahModel dataItem = dataItems[index];
              return FavTile(
                dataItem: dataItem,
                onRemove: () {
                  controller.writeFavourites(dataItem);
                  controller.itemsSpeaker();
                },
              );
            });
      }),
    );
  }
}

class FavouriteController extends GetxController {
  @override
  void onInit() {
    itemsSpeaker();
    super.onInit();
  }

  final AppController controller = Get.find<AppController>();

  RxList<String> favItems = <String>[].obs;

  itemsSpeaker() {
    favItems.value = preferences.getStringList('fav') ?? [];
  }

  writeFavourites(SurahModel dataItem) async {
    List<String> favourite = controller.readFavourites();
    String value = json.encode(dataItem.toMap());
    String fav = favourite.contains(value) ? 'Remove from' : 'Add to';
    favourite.contains(value) ? favourite.remove(value) : favourite.add(value);
    // favSurah = favourite.contains(value);
    await preferences.setStringList('fav', favourite);
    // print('fav: $favourite\ncon: ${favourite.contains(value)}');
    controller.snackBar('Success',
        txt1: '${dataItem.englishName} $fav Favourites');
    // setState(() {});
  }

  double? downloaded;
  bool downloading = false;

  setItem(List<String> value) async {
    await preferences.setStringList('fav', value);
  }
}

class FavouriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FavouriteController());
  }
}

class FavTile extends StatefulWidget {
  const FavTile({
    Key? key,
    required this.dataItem,
    required this.onRemove,
  }) : super(key: key);

  final SurahModel dataItem;
  final VoidCallback onRemove;

  @override
  State<FavTile> createState() => _FavTileState();
}

class _FavTileState extends State<FavTile> {
  // bool tap = false;
  final AppController controller = Get.find<AppController>();

  String fileName = '';

  @override
  void initState() {
    fileName = '${widget.dataItem.number}';
    checkFav();
    super.initState();
  }

  checkFav() {
    List<String> favourite = controller.readFavourites();
    String value = json.encode(widget.dataItem.toMap());
    favSurah = favourite.contains(value);
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
    File? result;
    String path = '${controller.fileFolder}$fileName.mp3';
    // await loadInterstitialAd().whenComplete(() async {
    //   await interstitialAd?.show();
    // });
    await adManager.showAd(AdUnits.interstitialVideoAdPlacementId);
    setState(() {
      downloading = true;
    });
    controller.snackBar('Please wait');
    if (!(controller.checkFiles(fileName))) {
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
          onDownloadCompleted: (String path) {
            downloading = false;
            controller.snackBar('File Downloaded',
                txt1: '${widget.dataItem.englishName} is downloaded');
            setState(() {});
          },
          onDownloadError: (String error) async {
            errorCall();
          });
      //   await dio.download(
      //         widget.dataItem.url,
      //         path,
      //         onReceiveProgress: (rec, all) {
      //           setState(() {
      //             downloaded = (rec / all);
      //           });
      //           if (downloaded == 1.0) {
      //             setState(() {
      //               downloading = false;
      //               controller.snackBar('File Downloaded',
      //                   txt1: '${widget.dataItem.englishName} is downloaded');
      //             });
      //           }
      //         },
      //       ).onError((error, stackTrace) => errorCall());
    } else {
      setState(() {
        downloading = false;
        // controller.snackBar('Success',
        //     txt1: '${widget.dataItem.englishName} has been deleted');
      });
      controller.deleteFile(path);
    }

    setState(() {});

    // await interstitialAd?.show();
  }

  errorCall() {
    downloading = false;
    downloaded = null;
    controller.snackBar('Error', txt1: 'Check Internet Connection');
    setState(() {});
  }

  bool favSurah = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.checkFiles(fileName)
            ? controller.setChildren(
                fileName,
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
                download: () {
                  Get.back();
                  downloader();
                  // adManager.showInterstitialAd();
                });

        // controller.downloader(dataItem.url,dataItem.englishName);
        // Get.to(PlayerScreen());
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
                          color: myWhite
                            ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        Text(
                          widget.dataItem.englishName,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          widget.dataItem.englishNameTranslation,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
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
                    PopupMenuButton(
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            onTap: widget.onRemove,
                            child: Text(
                                '${favSurah ? 'Remove from' : 'Add to'} Favorites'),
                          ),
                          PopupMenuItem(
                            onTap: downloader,
                            child: Text(
                              controller.checkFiles(fileName)
                                  ? 'Delete'
                                  : 'Offline Downloads',
                            ),
                          ),
                          const PopupMenuItem(
                            onTap: shareApp,
                            child: Text('Share'),
                          ),
                        ];
                      },
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

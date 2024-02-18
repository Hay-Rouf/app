import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get/get.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'adunit.dart';

class AdManager extends GetxController {
  // late final AppLifecycleReactor appLifecycleReactor;

  // AppOpenAd? _appOpenAd;
  //
  // bool _isShowingAd = false;
  //
  // bool get isAdAvailable {
  //   return _appOpenAd != null;
  // }
  //
  // Future<InitializationStatus> _initGoogleMobileAds() async {
  //   return await MobileAds.instance.initialize();
  // }

  Map<String, bool> placements = {
    AdUnits.interstitialVideoAdPlacementId: false,
    AdUnits.rewardedVideoAdPlacementId: false,
  };

  void _loadAds() {
    for (var placementId in placements.keys) {
      _loadAd(placementId);
    }
  }

  Future<void> _loadAd(String placementId) async {
    await UnityAds.load(
      placementId: placementId,
      onComplete: (placementId) {
        print('Load Complete $placementId');
        placements[placementId] = true;
      },
      onFailed: (placementId, error, message) =>
          print('Load Failed $placementId: $error $message'),
    );
  }

  Future<void> showAd(String placementId) async {
    placements[placementId] = false;
    await UnityAds.showVideoAd(
      placementId: placementId,
      onComplete: (placementId) {
        print('Video Ad $placementId completed');
        _loadAd(placementId);
      },
      onFailed: (placementId, error, message) {
        print('Video Ad $placementId failed: $error $message');
        _loadAd(placementId);
      },
      onStart: (placementId) => print('Video Ad $placementId started'),
      onClick: (placementId) => print('Video Ad $placementId click'),
      onSkipped: (placementId) {
        print('Video Ad $placementId skipped');
        _loadAd(placementId);
      },
    );
  }

  @override
  Future<void> onInit() async {
    // await _initGoogleMobileAds();
    // _loadAppOpenAd();
    _loadAds();
    // appLifecycleReactor = AppLifecycleReactor(adManager: AdManager());
    // appLifecycleReactor.listenToAppStateChanges();
    super.onInit();
  }

  @override
  void onClose() {
    // _appOpenAd?.dispose();
    super.onClose();
  }

// Future<void> _loadAppOpenAd() async {
//   AppOpenAd.load(
//     adUnitId: AdUnits.appOpen,
//     orientation: AppOpenAd.orientationPortrait,
//     adLoadCallback: AppOpenAdLoadCallback(
//       onAdLoaded: (ad) {
//         _appOpenAd = ad;
//       },
//       onAdFailedToLoad: (error) {
//         if (kDebugMode) {
//           print('AppOpenAd failed to load: $error');
//         }
//       },
//     ),
//     request: const AdRequest(),
//   );
// }

// Future<void> showAppOpenIfAvailable() async {
//   if (kDebugMode) {
//     print(isAdAvailable);
//   }
//   if (!isAdAvailable) {
//     if (kDebugMode) {
//       print('Tried to show ad before available.');
//     }
//     _loadAppOpenAd();
//     return;
//   }
//   if (_isShowingAd) {
//     if (kDebugMode) {
//       print('Tried to show ad while already showing an ad.');
//     }
//     return;
//   }
//   // Set the fullScreenContentCallback and show the ad.
//   _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
//     onAdShowedFullScreenContent: (ad) {
//       // _isShowingAd = true;
//       if (kDebugMode) {
//         print('$ad onAdShowedFullScreenContent');
//       }
//     },
//     onAdFailedToShowFullScreenContent: (ad, error) {
//       if (kDebugMode) {
//         print('$ad onAdFailedToShowFullScreenContent: $error');
//       }
//       _isShowingAd = false;
//       ad.dispose();
//       _appOpenAd = null;
//     },
//     onAdDismissedFullScreenContent: (ad) {
//       if (kDebugMode) {
//         print('$ad onAdDismissedFullScreenContent');
//       }
//       _isShowingAd = false;
//       ad.dispose();
//       _appOpenAd = null;
//      _loadAppOpenAd();
//     },
//   );
//   await _appOpenAd?.show();
// }
}

// class AppLifecycleReactor {
//   final AdManager adManager;
//
//   AppLifecycleReactor({required this.adManager});
//
//   void listenToAppStateChanges() {
//     AppStateEventNotifier.startListening();
//     AppStateEventNotifier.appStateStream
//         .forEach((state) => _onAppStateChanged(state));
//   }
//
//   void _onAppStateChanged(AppState appState) {
//     // Try to show an app open ad if the app is being resumed and
//     // we're not already showing an app open ad.
//     if (appState == AppState.foreground) {
//       adManager.showAd(AdUnits.interstitialVideoAdPlacementId);
//     }
//   }
// }

class BannerWidget extends StatefulWidget {
  const BannerWidget({Key? key}) : super(key: key);

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  // BannerAd? bannerAd;

  // Future<void> loadBanner() async {
  //   await BannerAd(
  //     adUnitId: AdUnits.banner,
  //     size: AdSize.banner,
  //     request: const AdRequest(),
  //     listener: BannerAdListener(
  //       onAdLoaded: (ad) {
  //         bannerAd = ad as BannerAd;
  //         setState(() {});
  //       },
  //       onAdFailedToLoad: (ad, error) {
  //         // Releases an ad resource when it fails to load
  //         ad.dispose();
  //         if (kDebugMode) {
  //           print(
  //               'Ad load failed (code=${error.code} message=${error.message})');
  //         }
  //       },
  //     ),
  //   ).load();
  //   setState(() {});
  // }
  // bool ready = false;
  //
  // Future<void> _loadAd() async {
  //   await UnityAds.load(
  //       placementId: AdUnits.bannerAdPlacementId,
  //       onComplete: (placementId) {
  //         print('Load Complete $placementId');
  //         placements[placementId] = true;
  // setState(() {
  //   ready = true;
  // });
  // },
  // onFailed: (placementId, error, message) {
  //   setState(() {
  //     ready = false;
  //   });
  //   print('Load Failed $placementId: $error $message');
  //   _loadAd();
  // });
  // print('ready: $ready');
  // }

  @override
  void initState() {
    // loadBanner();
    // _loadAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
        // ready == true
        //   ?
        UnityBannerAd(
      placementId: AdUnits.bannerAdPlacementId,
      onLoad: (placementId) => print('Banner loaded: $placementId'),
      onClick: (placementId) => print('Banner clicked: $placementId'),
      onShown: (placementId) => print('Banner shown: $placementId'),
      onFailed: (placementId, error, message) =>
          print('Banner Ad $placementId failed: $error $message'),
    );
    // : const SizedBox.shrink();
    // return
    //   bannerAd == null
    //     ?
    // const SizedBox.shrink()
    //     : ConstrainedBox(
    //         constraints: BoxConstraints(
    //           minWidth: AdSize.banner.width.toDouble(),
    //           minHeight: AdSize.banner.height.toDouble(),
    //           maxWidth: AdSize.fullBanner.width.toDouble(),
    //           maxHeight: AdSize.fullBanner.height.toDouble(),
    //         ),
    //         child: AdWidget(ad: bannerAd!));
  }
}

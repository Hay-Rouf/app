import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AdUnits {
  static late final String appOpen;
  static late final String interstitial;
  static late final String banner;

  static String get gameId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return kDebugMode ? '3054608' : '5542402';
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'your_ios_game_id';
    }
    return '';
  }

  static String get bannerAdPlacementId {
    return kDebugMode ? 'banner' : 'Banner_Android';
  }

  static String get interstitialVideoAdPlacementId {
    return kDebugMode ? 'video' : 'Interstitial_Android';
  }

  static String get rewardedVideoAdPlacementId {
    return kDebugMode ? 'rewardedVideo' : 'Rewarded_Android';
  }
}

openAds() async {
  Map json = jsonDecode(await rootBundle.loadString('asset/ads_units.json'));
  Map appAds = json[!kDebugMode ? 'alafasy' : 'test'];
  // json['alafasy'];
  AdUnits.banner = appAds['banner'];
  AdUnits.appOpen = appAds['appOpen'];
  AdUnits.interstitial = appAds['interstitial'];
  print(AdUnits.interstitial);
  return appAds;
}

// static String get native => 'ca-app-pub-3940256099942544/2247696110';
// static String get banner => 'ca-app-pub-3940256099942544/6300978111';
//
// static String get interstitial => 'ca-app-pub-3940256099942544/1033173712';
//
// App ID - ca-app-pub-1111111111111111~2222222222

// static const String Interstitial = 'ca-app-pub-3940256099942544/1033173712';
// static const String Rewarded = 'ca-app-pub-3940256099942544/5224354917';
// static const String AppOpenID = 'ca-app-pub-3940256099942544/3419835294';

// static const String RewardedVideoID =
//     'ca-app-pub-3940256099942544/5224354917';
// static const String NativeAdvanced = 'ca-app-pub-3940256099942544/2247696110';
// static const String NativeAdvancedVideo =
//     'ca-app-pub-3940256099942544/1044960115';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import '../export.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await MobileAds.instance.initialize();
  await findAppName();
  await openAds();
  UnityAds.init(
    gameId: AdUnits.gameId,
    testMode: true,
    onComplete: () {
      print('Initialization Complete, id: ${AdUnits.gameId}');
      // _loadAds();
    },
    onFailed: (error, message) =>
        print('Initialization Failed: $error $message'),
  );
  
  await JustAudioBackground.init();
  preferences = await SharedPreferences.getInstance();
  await GetStorage.init();
  runApp(const MyApp());
}

late SharedPreferences preferences;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: appName,
      theme: ThemeData(
        primaryColor: myBlue,
      ),
      initialRoute: SplashScreen.id,
      getPages: [
        GetPage(
          name: PlayerScreen.id,
          page: () => const PlayerScreen(),
        ),
        GetPage(
          name: DownLoadsScreen.id,
          page: () => const DownLoadsScreen(),
          binding: DownloadBinding(),
        ),
        GetPage(
          name: FavouriteScreen.id,
          page: () => const FavouriteScreen(),
          binding: FavouriteBinding(),
        ),
        GetPage(
          name: SurahListScreen.id,
          page: () => const SurahListScreen(),
        ),
        GetPage(
          name: SplashScreen.id,
          page: () => const SplashScreen(),
          binding: SplashBinding(),
        ),
      ],
      initialBinding: InitBinding(),
    );
  }
}

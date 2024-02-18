import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../export.dart';
import '../unity.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String id = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myWhite,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                assetImage,
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * .35,
            child: Text(
              'Sheikh $appName',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * .3,
            child: const Text(
              'Full Quran mp3',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SplashController extends GetxController {
  @override
  onInit() {
    getPermission();
    Timer(const Duration(seconds: 2), () {
      // Get.to(const UnityAdsExample());
      Get.offNamed(SurahListScreen.id);
    });
    super.onInit();
  }

  @override
  Future<void> onClose() async {
    // await adManager.showAd(AdUnits.interstitialVideoAdPlacementId);
    // await adManager.showAppOpenIfAvailable();
    super.onClose();
  }
}

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}

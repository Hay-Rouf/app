import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../export.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // surfaceTintColor: myWhite,
      backgroundColor: myWhite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    assetImage,
                    height: 150,
                    // width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    appName,
                    style: const TextStyle(color: myBlack,fontSize: 20,fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
            DrawerTile(
              icon: Icons.favorite,
              text: 'My Favorites',
              onTap: () {
                Get.toNamed(FavouriteScreen.id);
              },
            ),
            DrawerTile(
              icon: Icons.download,
              text: 'My Downloads',
              onTap: () {
                Get.toNamed(DownLoadsScreen.id);
              },
            ),
            DrawerTile(
              icon: Icons.privacy_tip,
              text: 'Privacy Policy',
              onTap: () async => await rateApp(privacyLink),
            ),
            DrawerTile(
              icon: Icons.star_rate,
              text: 'Rate App',
              onTap: () async => await rateApp(appLink),
            ),
            const DrawerTile(
              icon: Icons.share,
              text: 'Share App',
              onTap: shareApp,
            ),
            DrawerTile(
              icon: Icons.more,
              text: 'For More Apps',
              onTap: () async => await rateApp(moreApps),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
  });

  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: myBlack,
        size: 25,
      ),
      title: Text(
        text,
        style: const TextStyle(
          color: myBlack,
          fontSize: 18,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}

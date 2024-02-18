import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:path_provider/path_provider.dart';

import '../export.dart';

enum Loop { all, one, off }

class AppController extends GetxController {
  RxString onlineTitleAr = ''.obs;

  RxString onlineTitle = ''.obs;
  final GetStorage box = GetStorage('data');

  String fileFolder = 'HayRouf/$appName/'.replaceAll(' ', '_');

  @override
  Future<void> onInit() async {
    await _openJson();
    // final appDir = await getApplicationDocumentsDirectory();
    // allFav();
    dir = Directory('/storage/emulated/0/Download/$fileFolder');
    await GetStorage.init();
    super.onInit();
  }

  List<String> readFavourites() {
    List<String> fav = preferences.getStringList('fav') ?? [];
    return fav;
  }

  checkPlaying(bool value) {
    playing.value = value;
  }

  RxBool playing = false.obs;

  // RxBool favSurah = false.obs;
  //
  // checkFav(SurahModel model) {
  //   List<String> favourite = readFavourites();
  //   String value = json.encode(model.toMap());
  //   favSurah.value = favourite.contains(value);
  // }
  //
  // writeFavourites(SurahModel model) async {
  //   List<String> favourite = readFavourites();
  //   String value = json.encode(model.toMap());
  //   String fav = favSurah.value ? 'Removed from' : 'Added to';
  //   favSurah.value ? favourite.remove(value) : favourite.add(value);
  //   favSurah.value = favourite.contains(value);
  //   // await controller.box.write('fav', favourite);
  //   await preferences.setStringList('fav', favourite);
  //   // print('fav: $favourite\ncon: ${favourite.contains(value)}');
  //   snackBar('Success',
  //       txt1: '${model.englishName} $fav Favourites');
  // }

  late final Directory dir;

  final AudioPlayer _player = AudioPlayer();

  get playLength => _player.sequence?.length;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Stream<double> get speedStream => _player.speedStream;

  double get speed => _player.speed;

  deleteFile(String fileName) {
    File(fileName).delete();
    print(fileName);
    snackBar('Success', txt1: '$fileName has been deleted');
  }

  initSize(Size size) {
    size = size;
  }

  setSpeed(value) => _player.setSpeed(value);

  bool tapA = false;

  Stream get currentIndexStream => _player.currentIndexStream;

  List<AudioSource> list = [];

  Rx<Loop> loop = Loop.all.obs;

  changeLoop() async {
    if (loop.value == Loop.all) {
      loop.value = Loop.one;
      await _player.setLoopMode(LoopMode.one);
    } else if (loop.value == Loop.one) {
      loop.value = Loop.off;
      await _player.setLoopMode(LoopMode.off);
    } else if (loop.value == Loop.off) {
      loop.value = Loop.all;
      await _player.setLoopMode(LoopMode.all);
    }
  }

  bool checkFiles(String filename) {
    bool value = false;
    try {
      List<FileSystemEntity> files = dir.listSync();
      for (var element in files) {
        if (element.path.contains(filename)) {
          value = true;
        }
      }
    } catch (e) {
      value = false;
    }
    return value;
  }

  // RxString currentFile = ''.obs;

  // set currentFileIndexSetter(String value) => currentFile.value = value;

  Duration defaultDuration = const Duration(seconds: 2);

  Future<void> play() async {
    await _player.play();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> skipToNext() async {
    await _player.seekToNext();
  }

  Future<void> skipToPrevious() async {
    await _player.seekToPrevious();
  }

  Future<void> seek(Duration position) async {
    _player.seek(position);
  }

  stop() async {
    await _player.stop();
  }

  seekAudio(durationToSeek) async {
    if (durationToSeek is double) {
      await _player.seek(Duration(milliseconds: durationToSeek.toInt()));
      play();
    } else if (durationToSeek is Duration) {
      await _player.seek(durationToSeek);
      play();
    }
  }

  RxBool playOnline = false.obs;

  setOnlineSource({
    required String url,
    required String name,
    required String id,
  }) async {
    playOnline.value = true;
    onlineTitleAr.value = name;
    onlineTitle.value = id;
    Get.toNamed(PlayerScreen.id);
    await _player
        .setAudioSource(AudioSource.uri(
          Uri.parse(url),
          tag: MediaItem(
            id: id,
            title: name,
            artist: 'Abdul Rahman Ibn Abdul Aziz al-Sudais',
            artUri: await getImageFileFromAssets(),
          ),
        ))
        .onError((error, stackTrace) =>
            snackBar('Error', txt1: 'Check Internet Connection'));
    await _player.setLoopMode(LoopMode.one);
    checkPlaying(true);
    await play();
  }

  int total = 100;

  // getValue(double value) {
  //   return value;
  // }

  snackBar(String txt, {String? txt1}) {
    Get.snackbar(
      txt,
      txt1 ?? '',
      margin: const EdgeInsets.symmetric(horizontal: 70, vertical: 30),
      padding: const EdgeInsets.all(10),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  Stream<PositionData> get positionDataStream {
    return rx.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream,
        (position, bufferedPosition, duration) => PositionData(
            position, bufferedPosition, duration ?? Duration.zero));
  }

  getDownloads() {
    List<String> downloadedFiles = [];
    try {
      List<FileSystemEntity> files = dir.listSync();
      for (var element in files) {
        downloadedFiles.add(element.path);
      }
    } catch (e) {
      // value = false;
    }
    return downloadedFiles;
  }

  // Rx<String?> displaySurahEng = details[player.currentIndex!]['title'].obs;
  RxString displaySurahAr = ''.obs;

  List<Map<String, String>> details = [];

  RxInt get currentPlayerIndex => _player.currentIndex!.obs;

  setChildren(
    String currentFile,
  ) async {
    playOnline.value = false;
    details.clear();
    List<FileSystemEntity> filesData = dir.listSync();
    List files = [];
    int initIndex = 0;
    for (var element in filesData) {
      element.path.split('/').last.contains('-')
          ? null
          : files.add(element.path);
    }
    files.sort((a, b) => a
        .split('/')
        .last
        .split('_')
        .first
        .compareTo(b.split('/').last.split('_').first));
    List<AudioSource> children = [];
    for (String file in files) {
      if (file.contains(currentFile)) {
        initIndex = files.indexOf(file);
      }
      String split = file.split('/').last.replaceAll('.mp3', '');
      String id = split;
      String titleAr = getOtherInfo(int.parse(id)).name;
      // print('all: ${split[0]}');
      // print('f: ${split.first} l: ${split.last}');
      String title = getOtherInfo(int.parse(id)).englishName;
      Map<String, String> data = {
        'id': id,
        'title': title,
        'titleAr': titleAr,
      };
      details.add(data);
      children.add(
        AudioSource.uri(
          Uri.file(
            file,
          ),
          tag: MediaItem(
            id: id,
            title: title,
            artist: appName,
            artUri: await getImageFileFromAssets(),
          ),
        ),
      );
    }
    final playlist = ConcatenatingAudioSource(
      // Start loading next item just before reaching it
      useLazyPreparation: true,
      // Customise the shuffle algorithm
      shuffleOrder: DefaultShuffleOrder(),
      // Specify the playlist items
      children: children,
    );
    list = children;
    await _player.setAudioSource(playlist,
        initialIndex: initIndex, initialPosition: Duration.zero);
    _player.setLoopMode(LoopMode.all);
    play();
    checkPlaying(true);
    Get.toNamed(PlayerScreen.id);
  }

  String formatTime(Duration? duration) {
    String twoDigit(int n) => n.toString().padLeft(2, '0');
    if (duration != null) {
      final hour = twoDigit(duration.inHours);
      final minutes = twoDigit(duration.inMinutes.remainder(60));
      final seconds = twoDigit(duration.inSeconds.remainder(60));

      return [
        if (duration.inHours > 0) hour,
        minutes,
        seconds,
      ].join(':');
    } else {
      return '';
    }
  }

  Future<Uri> getImageFileFromAssets() async {
    final byteData = await rootBundle.load(assetImage);
    final buffer = byteData.buffer;
    Directory folder = await getApplicationDocumentsDirectory();
    var filePath = '${folder.path}/logo.png';
    File file = File(filePath);
    await file.create(recursive: true).whenComplete(
          () async => await file.writeAsBytes(
            buffer.asUint8List(
              byteData.offsetInBytes,
              byteData.lengthInBytes,
            ),
          ),
        );
    return file.uri;
  }

  RxList<SurahModel> surahs = <SurahModel>[].obs;
  RxList<String> surahNames = <String>[].obs;

  SurahModel getOtherInfo(int num) {
    return surahs.firstWhere((element) => element.number == num);
  }

  Future _openJson() async {
    List<SurahModel> models = [];
    var file = await rootBundle.loadString(assetJson);
    Map json = await jsonDecode(file);
    json['data'].forEach((element) {
      models.add(SurahModel.fromJson(element));
    });
    surahs.addAll(models);
    for (var element in surahs) {
      surahNames.add(element.englishName);
    }
  }
}

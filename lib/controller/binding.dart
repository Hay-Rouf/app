import 'package:get/get.dart';
import '../export.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AppController());
    Get.put(AdManager());
  }
}

final AppController appController = Get.find();
final AdManager adManager = Get.find();


import 'native_opencv_platform_interface.dart';

class NativeOpencv {
  Future<String?> getPlatformVersion() {
    return NativeOpencvPlatform.instance.getPlatformVersion();
  }

  String? getVersion() {
    return NativeOpencvPlatform.instance.getVersion();
  }

  Future<void> casCadeDetect(
      {required String imgPath,
      required String cascadeName,
      required String resultPath}) async {
    return await NativeOpencvPlatform.instance.casCadeDetect(
        imgPath: imgPath, cascadeName: cascadeName, resultPath: resultPath);
  }

  Future<int> templateMatching(
      {required String imagePath,
      required String templatePath,
      required String resultPath}) async {
    return await NativeOpencvPlatform.instance.templateMatching(
        imagePath: imagePath,
        templatePath: templatePath,
        resultPath: resultPath);
  }
}

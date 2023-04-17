import 'native_opencv_platform_interface.dart';

class NativeOpencv {
  Future<String?> getPlatformVersion() {
    return NativeOpencvPlatform.instance.getPlatformVersion();
  }

  String? getVersion() {
    return NativeOpencvPlatform.instance.getVersion();
  }

  void resize(
      {required String pathIn,
      required String pathOut,
      required int width,
      required int height}) {
    NativeOpencvPlatform.instance.resize(pathIn, pathOut, width, height);
  }

  void rectangle(
      {required String pathIn,
      required String pathOut,
      required int x,
      required int y,
      required int width,
      required int height,
      int c0 = 0,
      int c1 = 0,
      int c2 = 255,
      int thickness = 1,
      int lineType = 8,
      int shift = 0}) {
    NativeOpencvPlatform.instance.rectangle(pathIn, pathOut, x, y, width,
        height, c0, c1, c2, thickness, lineType, shift);
  }

  void faceDetection(
      {required String pathIn,
      required String pathOut,
      required String pathCascade}) {
    NativeOpencvPlatform.instance.faceDetection(pathIn, pathOut, pathCascade);
  }

  int templateMatching(
      {required String pathIn,
      required String pathOut,
      required String pathTemplate,
      int method = 3,
      double threshold = 0.9}) {
    return NativeOpencvPlatform.instance
        .templateMatching(pathIn, pathOut, pathTemplate, method, threshold);
  }
}

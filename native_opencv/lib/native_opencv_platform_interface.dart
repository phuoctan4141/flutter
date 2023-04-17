import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'native_opencv_method_channel.dart';

abstract class NativeOpencvPlatform extends PlatformInterface {
  /// Constructs a NativeOpencvPlatform.
  NativeOpencvPlatform() : super(token: _token);

  static final Object _token = Object();

  static NativeOpencvPlatform _instance = MethodChannelNativeOpencv();

  /// The default instance of [NativeOpencvPlatform] to use.
  ///
  /// Defaults to [MethodChannelNativeOpencv].
  static NativeOpencvPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NativeOpencvPlatform] when
  /// they register themselves.
  static set instance(NativeOpencvPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  String? getVersion() {
    throw UnimplementedError('nativeOpencvVersion() has not been implemented.');
  }

  void resize(String pathIn, String pathOut, int width, int height) {
    throw UnimplementedError('resize() has got problems.');
  }

  void rectangle(
      String pathIn,
      String pathOut,
      int x,
      int y,
      int width,
      int height,
      int c0,
      int c1,
      int c2,
      int thickness,
      int lineType,
      int shift) {
    throw UnimplementedError('rectangle() has got problems.');
  }

  void faceDetection(String pathIn, String pathOut, String pathCascade) {
    throw UnimplementedError('FaceDetection() has got problems.');
  }

  int templateMatching(String pathIn, String pathOut, String pathTemplate,
      int method, double threshold) {
    throw UnimplementedError('templateMatching() has got problems.');
  }
}

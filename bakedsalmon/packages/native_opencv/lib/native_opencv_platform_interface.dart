// ignore_for_file: unused_element, camel_case_types

import 'dart:ffi';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
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

  Future<void> casCadeDetect(
      {required String imgPath,
      required String cascadeName,
      required String resultPath}) async {
    throw UnimplementedError('casCadeDetect() has got problems.');
  }

  Future<int> templateMatching(
      {required String imagePath,
      required String templatePath,
      required String resultPath}) async {
    throw UnimplementedError('templateMatching() has got problems.');
  }
}

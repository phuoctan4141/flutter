// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'native_opencv_platform_interface.dart';

typedef _version_func = Pointer<Utf8> Function();
typedef _VersionFunc = Pointer<Utf8> Function();

typedef _resize_func = Void Function(
    Pointer<Utf8> pathIn, Pointer<Utf8> pathOut, Int32 width, Int32 height);
typedef _ResizeFunc = void Function(
    Pointer<Utf8> pathIn, Pointer<Utf8> pathOut, int width, int height);

typedef _rectangle_func = Void Function(
    Pointer<Utf8> pathIn,
    Pointer<Utf8> pathOut,
    Int32 x,
    Int32 y,
    Int32 width,
    Int32 height,
    Int32 c0,
    Int32 c1,
    Int32 c2,
    Int32 thickness,
    Int32 lineType,
    Int32 shift);

typedef _RectangleFunc = void Function(
    Pointer<Utf8> pathIn,
    Pointer<Utf8> pathOut,
    int x,
    int y,
    int width,
    int height,
    int c0,
    int c1,
    int c2,
    int thickness,
    int lineType,
    int shift);

typedef _face_detection_func = Void Function(
  Pointer<Utf8> pathIn,
  Pointer<Utf8> pathOut,
  Pointer<Utf8> pathCascade,
);

typedef _FaceDetectionFunc = void Function(
  Pointer<Utf8> pathIn,
  Pointer<Utf8> pathOut,
  Pointer<Utf8> pathCascade,
);

typedef _template_matching_func = Int32 Function(
  Pointer<Utf8> pathIn,
  Pointer<Utf8> pathOut,
  Pointer<Utf8> pathTemplate,
  Int32 method,
  Double threshold,
);

typedef _TemplateMatchingFunc = int Function(
  Pointer<Utf8> pathIn,
  Pointer<Utf8> pathOut,
  Pointer<Utf8> pathTemplate,
  int method,
  double threshold,
);

/// An implementation of [NativeOpencvPlatform] that uses method channels.
class MethodChannelNativeOpencv extends NativeOpencvPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('native_opencv');

  // Getting a library that holds needed symbols
  DynamicLibrary native_lib = Platform.isAndroid
      ? DynamicLibrary.open('libnative_opencv.so')
      : DynamicLibrary.process();

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  String? getVersion() {
    final func =
        native_lib.lookupFunction<_version_func, _VersionFunc>('version');
    String? ver = func().toDartString();
    return ver;
  }

  @override
  void resize(String pathIn, String pathOut, int width, int height) {
    final func = native_lib.lookupFunction<_resize_func, _ResizeFunc>('resize');
    func(pathIn.toNativeUtf8(), pathOut.toNativeUtf8(), width, height);
  }

  @override
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
    final func =
        native_lib.lookupFunction<_rectangle_func, _RectangleFunc>('rectangle');
    func(pathIn.toNativeUtf8(), pathOut.toNativeUtf8(), x, y, width, height, c0,
        c1, c2, thickness, lineType, shift);
  }

  @override
  void faceDetection(String pathIn, String pathOut, String pathCascade) {
    final func =
        native_lib.lookupFunction<_face_detection_func, _FaceDetectionFunc>(
            'faceDetection');
    func(pathIn.toNativeUtf8(), pathOut.toNativeUtf8(),
        pathCascade.toNativeUtf8());
  }

  @override
  int templateMatching(String pathIn, String pathOut, String pathTemplate,
      int method, double threshold) {
    final func = native_lib.lookupFunction<_template_matching_func,
        _TemplateMatchingFunc>('templateMatching');

    return func(pathIn.toNativeUtf8(), pathOut.toNativeUtf8(),
        pathTemplate.toNativeUtf8(), method, threshold);
  }
}

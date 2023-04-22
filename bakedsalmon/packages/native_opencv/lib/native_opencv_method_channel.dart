// ignore_for_file: camel_case_types, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, unused_element

import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';

import 'native_opencv_platform_interface.dart';

typedef _version_func = Pointer<Utf8> Function();
typedef _VersionFunc = Pointer<Utf8> Function();

typedef _casCadeDetect_func = Void Function(
    Pointer<Utf8> imgPath, Pointer<Utf8> cascadeName, Pointer<Utf8> resultPath);
typedef _CasCadeDetectFunc = void Function(
    Pointer<Utf8> imgPath, Pointer<Utf8> cascadeName, Pointer<Utf8> resultPath);

typedef _templateMatching_func = Int32 Function(
    Pointer<Utf8> imgPath, Pointer<Utf8> tempPath, Pointer<Utf8> resultPath);
typedef _TemplateMatchingFunc = int Function(
    Pointer<Utf8> imgPath, Pointer<Utf8> tempPath, Pointer<Utf8> resultPath);

final _version =
    native_lib.lookupFunction<_version_func, _VersionFunc>('version');
final _casCadeDetect = native_lib
    .lookupFunction<_casCadeDetect_func, _CasCadeDetectFunc>('casCadeDetect');
final _templateMatching =
    native_lib.lookupFunction<_templateMatching_func, _TemplateMatchingFunc>(
        'templateMatching');

// Getting a library that holds needed symbols
DynamicLibrary native_lib = Platform.isAndroid
    ? DynamicLibrary.open('libnative_opencv.so')
    : DynamicLibrary.process();

// Getting a function from the library

//https://groups.google.com/g/flutter-dev/c/LLWPwBJLizc/m/yOs6kXuKAQAJ
extension Uint8ListBlobConversion on Uint8List {
  /// Allocates a pointer filled with the Uint8List data.
  Pointer<Uint8> allocatePointer() {
    final blob = calloc<Uint8>(length);
    final blobBytes = blob.asTypedList(length);
    blobBytes.setAll(0, this);
    return blob;
  }
}

/// An implementation of [NativeOpencvPlatform] that uses method channels.
class MethodChannelNativeOpencv extends NativeOpencvPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('native_opencv');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  String? getVersion() {
    return _version.toString();
  }

  @override
  Future<void> casCadeDetect(
      {required String imgPath,
      required String cascadeName,
      required String resultPath}) async {
    // set up the arguments to pass to the native library
    final _imgPath = imgPath.toNativeUtf8();
    var _cascadePath = cascadeName.toNativeUtf8();
    final _resultPath = resultPath.toNativeUtf8();

    var cascadeFile = await loadHaarCascadeFromAssets(cascadeName);
    _cascadePath = cascadeFile.path.toNativeUtf8();

    try {
      // call the native library
      _casCadeDetect(_imgPath, _cascadePath, _resultPath);
    } catch (e) {
      // handle the error
      // ignore: avoid_print
      print('casCadeDetect() error: ${e.toString()}');
    } finally {
      // free the memory
      malloc.free(_imgPath);
      malloc.free(_cascadePath);
      malloc.free(_resultPath);
    }
  }

  @override
  Future<int> templateMatching(
      {required String imagePath,
      required String templatePath,
      required String resultPath}) async {
    // set up the arguments to pass to the native library
    final _imagePath = imagePath.toNativeUtf8();
    final _templatePath = templatePath.toNativeUtf8();
    final _resultPath = resultPath.toNativeUtf8();
    int count = 0;

    try {
      // call the native library
      count = _templateMatching(_imagePath, _templatePath, _resultPath);
      print('templateMatching() count: $count');
    } finally {
      // free the memory
      malloc.free(_imagePath);
      malloc.free(_templatePath);
      malloc.free(_resultPath);
    }

    return count;
  }

  // https://stackoverflow.com/a/71186701
  static Future<File> loadHaarCascadeFromAssets(String fileName) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final filePath = "$tempPath/$fileName";
    final file = File(filePath);
    if (!file.existsSync()) {
      final cascadeXml = await rootBundle
          .loadString('packages/native_opencv/assets/haarcascades/$fileName');
      final document = XmlDocument.parse(cascadeXml);
      return compute(_writeXmlFile, [filePath, document.toString()]);
    }
    return file;
  }

  static Future<File> _writeXmlFile(List<String> args) async {
    final filePath = args[0];
    final xmlString = args[1];
    return File(filePath)
        .writeAsString(xmlString, mode: FileMode.write, flush: true);
  }
}

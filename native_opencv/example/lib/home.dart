// ignore_for_file: library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:native_opencv/native_opencv.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  // native_opencv
  final _nativeOpencvPlugin = NativeOpencv();

  /// Variables
  File? imageFile;

  @override
  void initState() {
    super.initState();
    copyFolder();
  }

  /// Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Picker"),
      ),
      bottomNavigationBar: SafeArea(
        child: BottomAppBar(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  _getFromGallery();
                },
                child: const Text("PICK FROM GALLERY"),
              ),
              Container(
                height: 40.0,
              ),
              ElevatedButton(
                onPressed: () {
                  _getFromCamera();
                },
                child: const Text("PICK FROM CAMERA"),
              )
            ],
          ),
        ),
      ),
      body: Center(
        child: Container(
          child: imageFile == null
              ? Container(
                  alignment: Alignment.center,
                  child: const Text("No Image Selected"),
                )
              : Container(
                  alignment: Alignment.center,
                  child: Image.file(
                    imageFile!,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
    );
  }

  /// Get from gallery
  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        var _imageFile = File(pickedFile.path);
        _nativeOpencvPlugin.resize(
            pathIn: _imageFile.path,
            pathOut: _imageFile.path,
            width: 300,
            height: 300);
        imageFile = _imageFile;
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        var _imageFile = File(pickedFile.path);
        _faceDetection(_imageFile);
        imageFile = _imageFile;
      });
    }
  }

  _faceDetection(File _imageFile) async {
    const pathCascade =
        "assets/haarcascades/haarcascade_frontalface_default.xml";
    final _cascadeFile = File(pathCascade);

    if (_cascadeFile.existsSync()) {
      _nativeOpencvPlugin.faceDetection(
          pathIn: _imageFile.path,
          pathOut: _imageFile.path,
          pathCascade: _cascadeFile.path);
    } else {
      print("Cascade file not found");
    }
  }

  Future<File> moveFile(File sourceFile, String newPath) async {
    try {
      /// prefer using rename as it is probably faster
      /// if same directory path
      return await sourceFile.rename(newPath);
    } catch (e) {
      /// if rename fails, copy the source file
      final newFile = await sourceFile.copy(newPath);
      return newFile;
    }
  }

  void copyFolder() async {
    final from = join("assets", "haarcascades");
    final _cascadeFolder = join(await _localPath, "haarcascades");
    final _cascadeFolderFile = Directory(_cascadeFolder);

    if (!_cascadeFolderFile.existsSync()) {
      await _cascadeFolderFile.create(recursive: true);
      await for (final file in Directory(from).list(recursive: true)) {
        final copyTo = join(_cascadeFolder, relative(file.path, from: from));
        if (file is Directory) {
          await Directory(copyTo).create(recursive: true);
        } else if (file is File) {
          await File(file.path).copy(copyTo);
        } else if (file is Link) {
          await Link(copyTo).create(await file.target(), recursive: true);
        }
      }
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
}

// ignore_for_file: library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:native_opencv/native_opencv.dart';

class CasCadePage extends StatefulWidget {
  const CasCadePage({super.key});

  @override
  _CasCadePageState createState() => _CasCadePageState();
}

class _CasCadePageState extends State<CasCadePage> {
  // native_opencv
  final _nativeOpencvPlugin = NativeOpencv();

  /// Variables
  File? imageFile;

  @override
  void initState() {
    super.initState();
  }

  /// Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CasCade Detection Page"),
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
      body: SingleChildScrollView(
        child: Center(
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
      ),
    );
  }

  /// Get from gallery
  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      var _imageFile = File(pickedFile.path);
      await _faceDetection(_imageFile);
      setState(() {
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
      var _imageFile = File(pickedFile.path);
      await _faceDetection(_imageFile);
      setState(() {
        imageFile = _imageFile;
      });
    }
  }

  Future<void> _faceDetection(File _imageFile) async {
    String cascadeName = "haarcascade_frontalface_alt.xml";

    await _nativeOpencvPlugin.casCadeDetect(
        imgPath: _imageFile.path,
        cascadeName: cascadeName,
        resultPath: _imageFile.path);
  }
}

// ignore_for_file: no_leading_underscores_for_local_identifiers, file_names

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:native_opencv/native_opencv.dart';

class TemplatePage extends StatefulWidget {
  const TemplatePage({super.key});

  @override
  State<TemplatePage> createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage> {
  final NativeOpencv _nativeOpencvPlugin = NativeOpencv();

  /// Variables
  File? stockFile;
  File? templateFile;
  Uint8List? resultFile;
  int result = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Template Matching Page"),
      ),
      bottomNavigationBar: SafeArea(
        child: BottomAppBar(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await _getStock();
                  },
                  child: const Text("PICK STOCK"),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _getTemplate();
                  },
                  child: const Text("PICK TEMPLATE"),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await _templateMatching();
                  },
                  child: const Text("TEMPLATE MATCHING"),
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Divider(),
              templateFile == null
                  ? const Text("Template null")
                  : Container(
                      alignment: Alignment.center,
                      child: Image.file(
                        templateFile!,
                        fit: BoxFit.cover,
                      ),
                    ),
              const Divider(),
              stockFile == null
                  ? const Text("Stock null")
                  : Container(
                      alignment: Alignment.center,
                      child: Image.file(
                        stockFile!,
                        fit: BoxFit.cover,
                      ),
                    ),
              const Divider(),
              Container(
                alignment: Alignment.center,
                child: Text("Result: $result"),
              ),
              const Divider(),
              resultFile == null
                  ? const Text("Result null")
                  : Container(
                      alignment: Alignment.center,
                      child: Image.memory(
                        resultFile!,
                        fit: BoxFit.cover,
                      ),
                    ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }

  void _getTemplate() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // pickedFile is a File object
      setState(() {
        templateFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _getStock() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // pickedFile is a File object'
      setState(() {
        stockFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _templateMatching() async {
    if (stockFile != null && templateFile != null) {
      var _imageFile = stockFile?.copySync(
          "${stockFile!.path.substring(0, stockFile!.path.lastIndexOf("/"))}/result.jpg");
      //var _decodedImage = await decodeImageFromList(_imageFile);
      try {
        result = await _nativeOpencvPlugin.templateMatching(
          imagePath: stockFile!.path,
          templatePath: templateFile!.path,
          resultPath: _imageFile!.path,
        );
      } finally {
        if (mounted) {
          var _imageByte = _imageFile!.readAsBytesSync();
          setState(() {
            resultFile = _imageByte;
          });
        }
      }
    }
  }
}

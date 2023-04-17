// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:io';

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
  File? resultFile;
  int result = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Template Page"),
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
                  onPressed: () {
                    _getStock();
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
                  onPressed: () {
                    _templateMatching();
                  },
                  child: const Text("TEMPLATE MATCHING"),
                ),
              )
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
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
                    child: Image.file(
                      resultFile!,
                      fit: BoxFit.cover,
                    ),
                  ),
          ],
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

  void _getStock() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // pickedFile is a File object
      setState(() {
        stockFile = File(pickedFile.path);
      });
    }
  }

  void _templateMatching() async {
    if (stockFile != null && templateFile != null) {
      var _imageFile = File(stockFile!.path);

      result = _nativeOpencvPlugin.templateMatching(
          pathIn: stockFile!.path,
          pathOut: _imageFile.path,
          pathTemplate: templateFile!.path);

      setState(() {
        resultFile = _imageFile;
      });
    }
  }
}

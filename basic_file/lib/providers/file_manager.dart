// ignore_for_file: unused_element, avoid_print, unused_import

import 'dart:convert';
import 'dart:io';

import 'package:basic_file/providers/encrypt_data.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {
  static String folderName = "basic_file";
  static String fileName = "store.json";
  static FileManager? _instance;

  FileManager._internal() {
    _instance = this;
  }

  factory FileManager() => _instance ?? FileManager._internal();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$folderName/$fileName');
  }

  Future<bool> isExists() async {
    try {
      final file = await _localFile;
      if (file.existsSync()) return true;
    } catch (e) {
      return false;
    }

    return false;
  }

  Future<String> createJsonFile() async {
    String state = "false";

    isExists().then((value) async {
      if (value) state = "exist";

      final file = await _localFile;
      file.createSync(recursive: true);

      state = "new";
    });

    return state;
  }

  Future readJsonFile() async {
    String fileContent = 'Mutiverse';

    File file = await _localFile;

    try {
      fileContent = await file.readAsString();
      return json.decode(EncryptData.decryptAES(fileContent));
    } catch (e) {
      print(e);
    }

    return [];
  }

  Future<String> writeJsonFile(jsontext) async {
    File file = await _localFile;
    file.writeAsStringSync(
        EncryptData.encryptAES(json.encode(jsontext).toString()));
    return "notWrite";
  }
}

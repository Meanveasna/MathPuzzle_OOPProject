import 'dart:convert';
import 'dart:io';


class FileStorage {
  static final FileStorage _instance = FileStorage._internal();
  
  factory FileStorage() {
    return _instance;
  }

  FileStorage._internal();

  final String _fileName = 'user_data.csv';

  Future<File> get _localFile async {
    return File(_fileName);
  }

  // Returns a List of rows, where each row is a List of Strings
  Future<List<List<String>>> readCsv() async {
    try {
      final file = await _localFile;
      print("Reading CSV from: ${file.absolute.path}");
      if (!await file.exists()) {
        return [];
      }
      List<String> lines = await file.readAsLines();
      return lines.map((line) => line.split(',')).toList();
    } catch (e) {
      print("Error reading CSV: $e");
      return [];
    }
  }

  // Writes list of rows to CSV
  Future<void> writeCsv(List<String> lines) async {
    try {
      final file = await _localFile;
      print("Writing CSV to: ${file.absolute.path}");
      await file.writeAsString(lines.join('\n'));
    } catch (e) {
      print("Error writing CSV: $e");
    }
  }
}

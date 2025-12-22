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
      if (!await file.exists()) {
        return [];
      }
      List<String> lines = await file.readAsLines();
      // Skip header if exists, or handle in repository
      // Simple splitting by comma. NOTE: Does not handle commas inside fields.
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
      await file.writeAsString(lines.join('\n'));
    } catch (e) {
      print("Error writing CSV: $e");
    }
  }
}

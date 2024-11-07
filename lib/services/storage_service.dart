import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final storage = const FlutterSecureStorage();

  Future<void> saveData(String key, String value) async {
    storage.write(key: key, value: value);
  }

  Future<String?> getData(String key) async {
    return storage.read(key: key);
  }
}

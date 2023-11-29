import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  FlutterSecureStorage storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  //// ADDRESS ////
  Future<String?> readAddress() async {
    return await storage.read(key: 'address');
  }

  Future<void> setAddress(String value) async {
    await storage.write(key: 'address', value: value);
  }

  Future<void> deleteEmail() async {
    await storage.delete(key: 'address');
  }
  //// ADDRESS ////

  //// CONNECTED ////
  Future<String?> readConnected() async {
    return await storage.read(key: 'connected');
  }

  Future<void> setConnected(String value) async {
    await storage.write(key: 'connected', value: value);
  }

  Future<void> deleteConnected() async {
    await storage.delete(key: 'connected');
  }
  //// ADDRESS ////
}

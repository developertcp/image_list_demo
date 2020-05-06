import 'package:flutter/material.dart';

class FireStorageService extends ChangeNotifier {
  FireStorageService._();
  FireStorageService();
  static Future<dynamic> loadImage(BuildContext context, String image) {
    throw ("Platform not found");
  }
}

Future<String> getItemUrl(String filename) async {
  return Future.value("unsupported platform");
}

void getItemsAll() async {
  // return await FirebaseStorage.instance.ref().child(__).getDownloadURL();
  print("unsupported");
}

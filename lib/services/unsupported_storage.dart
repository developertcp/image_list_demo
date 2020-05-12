import 'package:flutter/material.dart';
import 'package:image_list/models/item_model.dart';

class FireStorageService extends ChangeNotifier {
  FireStorageService._();
  FireStorageService();
  static Future<dynamic> loadImage(BuildContext context, String image) {
    throw ("Platform not found");
  }
}

//temp
void apiGetAllItems(){}

Future<String> getItemUrl(String filename) async {
  return Future.value("unsupported platform");
}

Future<List<Item>> getItemsAll() async {
  print("unsupported platform");
  return Future.value([
    Item(
      itemId: 'Unsupported',
      itemName: 'Unsuppoerted Platform',
      imageRef: "unsupported.png",
    ),
  ]);
}

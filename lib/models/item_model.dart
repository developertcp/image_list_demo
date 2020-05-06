// import 'package:image_list/services/Item_API.dart';

// import 'package:flutter/material.dart';
import 'package:image_list/services/firebase_storage_service.dart';

class Item {
  final String itemId;
  final String itemName;
  final String imageRef;

  Item({this.itemId, this.itemName, this.imageRef});
}

// Future<Widget> getImage(BuildContext context, String image) async {
//   Image m;
//   await FirebaseStorageService.loadFromStorage(context, image).then((downloadUrl) {
//     m = Image.network(
//       downloadUrl.toString(),
//       fit: BoxFit.scaleDown,
//     );
//   });

//   return m;
// }

Future<Item> fetchItem() async {
//  final response = await apiGetItemsRandom(count: 1);
  return Future.value(Item(
      itemId: 'KB332', itemName: 'Keyboard 104-key', imageRef: 'keyboard.png'));
}

Future<List<Item>> fetchItems({int count = 3}) async {
  // return await apiGetItemsRandom(count: count);
// List<Item> items;
// await getItemUrl('Bottle20L.png').then((url) => 
// items =  [
//     Item(
//       itemId: 'Bottle20L',
//       itemName: '20 Liter Bottle',
//       imageRef: url,
//     ),
//   ]);
// return items;

var bottleUrl = await getItemUrl('Bottle20L.png');

  return Future.value([
    Item(
      itemId: 'Bottle20L',
      itemName: '20 Liter Bottle',
      imageRef: bottleUrl,
    ),
  ]);

//

  // return Future.value([
  //   Item(
  //     itemId: 'CP121',
  //     itemName: 'Standard Cup',
  //     imageRef: 'cup.png',
  //   ),
  //   Item(
  //     itemId: 'SCRFH1',
  //     itemName: 'Flathead Screwdriver',
  //     imageRef: 'screwdriver.png',
  //   ),
  // ]);
}

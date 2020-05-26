import 'package:image_list/services/firebase_storage_service.dart';

class Item {
  final String itemId;
  final String itemName;
  final String imageRef;

  Item({this.itemId, this.itemName, this.imageRef});
}

Future<List<Item>> fetchItemsAll({int count = 3}) async {
  final allStorageItems = await FireStorageService().getStorageItemsAll(folder: '');
  // final allStorageItems = await getStorageItemsAll(folder: 'test');
  List<Item> allItems = [];
  for(var item in allStorageItems) {
    allItems.add(
    Item(
      itemId: item.filename,
      itemName: item.name,
      imageRef: item.url,
    ));
  }
  return allItems;
}

Future<List<Item>> getItemsMock() async {
  return Future.value([
    Item(
      itemId: 'CLK15',
      itemName: 'Standard Clock',
      imageRef: '/storage/emulated/0/app images/015-clock.png',
    ),
    Item(
      itemId: 'TTFAN',
      itemName: 'Non-Adjustable Fan',
      imageRef: '/storage/emulated/0/app images/040-fan.png',
    ),
  ]);  
}

// Future<Item> fetchItem() async {
//   var bottleUrl = await FireStorageService.getItemUrl('Bottle20L.png');
//   return Future.value(
//     Item(
//       itemId: 'Bottle20L',
//       itemName: '20 Liter Bottle',
//       imageRef: bottleUrl,
//     ),
//   );
// }

// Future<List<Item>> fetchItems({int count = 3}) {
//   return Future.value([
//     Item(
//       itemId: 'CP121',
//       itemName: 'Standard Cup',
//       imageRef: 'cup.png',
//     ),
//     Item(
//       itemId: 'SCRFH1',
//       itemName: 'Flathead Screwdriver',
//       imageRef: 'screwdriver.png',
//     ),
//   ]);
// }
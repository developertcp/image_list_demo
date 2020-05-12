// //fire_storage_service.dart
// export 'unsupported_storage.dart'
//     if (dart.library.html) 'web_storage.dart'
//     if (dart.library.io) 'mobile_storage.dart';

// //unsupported_storage.dart
// import 'package:flutter/material.dart';

// class FirebaseStorageService extends ChangeNotifier {
//   FirebaseStorageService._();
//   FirebaseStorageService();

//   static Future<dynamic> loadFromStorage(BuildContext context, String image) {
//     throw ("Platform not found");
//   }

// import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:firebase/firebase.dart';

//mobile_storage.dart
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_list/models/item_model.dart';
// import 'package:flutter/material.dart';

// class FirebaseStorageService extends ChangeNotifier {
//   FirebaseStorageService._();
//   FirebaseStorageService();

//   static Future<dynamic> loadFromStorage(
//       BuildContext context, String image) async {
//     return await FirebaseStorage.instance.ref().child(image).getDownloadURL();
//   }
// }

//
// custom code

Future<String> getItemUrl(String filename) async {
  //   initializeApp(
  //       apiKey: "AIzaSyDEktNdn4CsMUxeOyVkPFBnaoAdNhcpEPc",
  //       authDomain: "fir-recipes-b5611.firebaseapp.com",
  //       databaseURL: "https://fir-recipes-b5611.firebaseio.com",
  //       projectId: "fir-recipes-b5611",
  //       storageBucket: "fir-recipes-b5611.appspot.com",
  //       messagingSenderId: "728428768644");

  // return await storage().ref('filename').getDownloadURL().toString();

  // return Future.value(
  //     "https://img.icons8.com/material-sharp/50/000000/delete-link.png");

  // print('filename: '+filename);
  try {
    var url = await storage().ref(filename).getDownloadURL();
    // print(url.toString());
    return Future.value(url.toString()); // convert URI to explicit string
  } catch (err) {
    print('Error in getDownloadURL for $filename: ' + err.toString());
    return (err.toString());
  }
}

// Future<String> getItemsAll() async {
Future<List<Item>> getItemsAll() async {
  // List<Item> items = [];
  // ListOptions options = ListOptions(maxResults: 100);
  // await storage()
  //     .ref("")
  //     // .list(options)
  //     .listAll()
  //     .then((list) => {
  //           list.items.forEach((itemRef) async {
  //             // final urlRoot = itemRef.selfLink;
  //             // final token = itemRef.metadata.firebaseStorageDownloadTokens;
  //             // final url = urlRoot+"?alt=media&token="+token;
  //             // print(url);
  //             final url = await getItemUrl(itemRef.name);
  //             items.add(Item(
  //   itemId: 'Bottle20L',
  //   itemName: '20 Liter Bottle',
  //   imageRef: url));
  //   // print(items.toString());
  //             // print(itemRef.toString());
  //             });
  //              return item;
  //         }).then((x) => print(items.toString()));
  //     // .catchError((e) => {print("Error:" + e)});

  List<Item> items = [];
  List<Future> futures = [];
  final results = await storage().ref("").listAll(); // listAll does not recurse through subfolders
  final resultItems = results.items;
  for (var itemRef in resultItems) {
    futures.add(buildItem(itemRef).then((x) => items.add(x)));
  }
  await Future.wait(futures);

  // print(items.toString());

  // for (var i in items) {
  //   print(i.imageRef);
  // }
  return items;
  // await Future.forEach(resultItems, (itemRef) => {
  //   getItemUrl(itemRef.name).then((url) => items.add(Item(
  //       itemId: 'Bottle20L', itemName: '20 Liter Bottle', imageRef: url))
// )
//     }).then((x) => print(items.toString() )
// );

  // resultItems.forEach((itemRef) async {
  //   final url = await getItemUrl(itemRef.name);
  //   items.add(Item(
  //       itemId: 'Bottle20L', itemName: '20 Liter Bottle', imageRef: url));
  // });
  // print(items.toString());

  // var url = await storage().ref(__).getDownloadURL();
  // return Future.value(url.toString());
}

Future<Item> buildItem(itemRef) async {
  // print(itemRef.toString());
  // File file = File("/dev/dart/work/hello/app.dart");
  // path.basenameWithoutExtension("/dev/dart/work/hello/app.dart");
  // print(path.basenameWithoutExtension("/dev/dart/work/hello/app.dart"));
  final url = await getItemUrl(itemRef.name);
  //RegEx after / before . https://stackoverflow.com/a/57186644 and https://stackoverflow.com/a/3671731
  final filenameNoExt =
      RegExp(r"([\w\d_-]*)\.?[^\\\/]*$").firstMatch(itemRef.name).group(1);

  return Item(
      itemId: filenameNoExt,
      itemName: path.basenameWithoutExtension(url),
      imageRef: url);
}

//

// //web_storage.dart
// import 'package:firebase/firebase.dart';
// import 'package:flutter/material.dart';

// class FirebaseStorageService extends ChangeNotifier {
//   FirebaseStorageService._();

//   FirebaseStorageService() {
//     initializeApp(
//         apiKey: "AIzaSyDEktNdn4CsMUxeOyVkPFBnaoAdNhcpEPc",
//         authDomain: "fir-recipes-b5611.firebaseapp.com",
//         databaseURL: "https://fir-recipes-b5611.firebaseio.com",
//         projectId: "fir-recipes-b5611",
//         storageBucket: "fir-recipes-b5611.appspot.com",
//         messagingSenderId: "728428768644");
//   }

//   static Future<dynamic> loadFromStorage(
//       BuildContext context, String image) async {
//     var url = await storage().ref(image).getDownloadURL();
//     return url;
//   }
// }

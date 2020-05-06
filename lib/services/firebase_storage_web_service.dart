
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
    var url = await storage().ref(filename).getDownloadURL();
    return Future.value(url.toString());

    // return Future.value(
    //     "https://img.icons8.com/material-sharp/50/000000/delete-link.png");

}

// Future<String> getItemsAll() async {
void getItemsAll() async {

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
    final results = await storage().ref("").listAll();
    final resultItems = results.items;
    for (var itemRef in resultItems) {
      futures.add(buildItem(itemRef).then((x) => items.add(x)));
    }
    await Future.wait(futures);

    print(items.toString());

    for (var i in items) {
      print(i.imageRef);
    }
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
  final url = await getItemUrl(itemRef.name);
  return Item(itemId: 'Bottle20L', itemName: '20 Liter Bottle', imageRef: url);
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

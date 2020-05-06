
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

// import 'package:firebase/firebase.dart';

//mobile_storage.dart
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_list/models/item_model.dart';


// from demo code
import 'package:flutter/material.dart';
class FireStorageService extends ChangeNotifier {
  FireStorageService();
static Future<dynamic> loadImage(BuildContext context, String image) async {
    return await FirebaseStorage.instance.ref().child(image).getDownloadURL();
  }
}

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
    return await FirebaseStorage.instance
        .ref()
        .child(filename)
        .getDownloadURL();
}

// Future<String> getItemsAll() async {
void getItemsAll() async {
    // return await FirebaseStorage.instance.ref().child(__).getDownloadURL();
    print("native");
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

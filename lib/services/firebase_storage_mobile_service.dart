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
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_list/models/item_model.dart';

import 'package:googleapis/storage/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/services.dart' show rootBundle;

//temp
import 'package:http/http.dart' as http;

// from demo code
import 'package:flutter/material.dart';

class FireStorageService extends ChangeNotifier {
  FireStorageService();
// static Future<dynamic> loadImage(BuildContext context, String image) async {
//     return await FirebaseStorage.instance.ref().child(image).getDownloadURL();
//   }

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
  // print('filename: '+filename);
  try {
    return await FirebaseStorage.instance
        .ref()
        .child(filename)
        .getDownloadURL();
  } catch (err) {
    print('Error in getDownloadURL for $filename: ${err.toString()}');
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

  // print(items.toString());

  // for (var i in items) {
  //   print(i.imageRef);
  // }

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

  List<Item> items = [];
  List<Future> futures = [];
  final gapiKey =
      await rootBundle.loadString('assets/text/gapi_service_acct_key.json');
  final _credentials = new ServiceAccountCredentials.fromJson(gapiKey);
  const _SCOPES = const [StorageApi.DevstorageReadOnlyScope];
  final bucket = await FirebaseStorage.instance.ref().getBucket();
  final httpClient = await clientViaServiceAccount(_credentials, _SCOPES);
// final storage = StorageApi(httpClient);
  final response = await httpClient
      .get('https://storage.googleapis.com/storage/v1/b/$bucket/o');
  if (response.statusCode == 200) {
    print('successful API return');
    // If the server did return a 200 OK response, then parse the JSON.
    // final data = json.decode(response.body)['items'];
    final resultItems = json.decode(response.body)['items'];
    //print('data: ' + resultItems[1].toString());
    // process data in incoming body and export as array of objects
    for (var itemRef in resultItems) {
      // mediaLink and selfLink returned from cloud storage require further authentication to access. Dropping code in favor or Firebase Storage pattern
      // items.add(Item(
      //     itemId: itemRef['name'],
      //     itemName: path.basenameWithoutExtension(itemRef['name']),
      //     imageRef: itemRef['mediaLink']));
      // items.add(d);
      // print('name: ${itemRef['name']}');
      if (path.extension(itemRef['name']) != '') {
        // if ref has extension (not a subfolder)
        // print('extension: ' + path.extension(itemRef['name']));
        futures.add(buildItem(itemRef['name']).then((x) => items.add(x)));
      }
    }
    await Future.wait(futures);

    return items;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception(
        'Failed to load items. Response Status Code: ${response.statusCode.toString()}');
  }

  // final results = await storage().ref("").listAll();
  // //final resultItems = results.items;
  // for (var itemRef in resultItems) {
  //   futures.add(buildItem(itemRef).then((x) => items.add(x)));
  // }
  // await Future.wait(futures);

  //   // return await FirebaseStorage.instance.ref().child(__).getDownloadURL();
  //   print("native");
  //     var bottleUrl = await getItemUrl('Bottle20L.png');
  // return Future.value([
  //   Item(
  //     itemId: 'Bottle20L',
  //     itemName: '20 Liter Bottle',
  //     imageRef: bottleUrl,
  //   ),
  // ]);
}

// void getCurrentUser() async {
//   try {
//     final user = await _auth.currentUser();
//     if (user != null) {
//       loggedInUser = user;
//       print(loggedInUser.email);
//     }
//   } catch (e) {
//     print(e);
//   }
// }

Future<List<Item>> apiGetAllItems({int count = 1}) async {
  print('running apiGetAllItems from Moble Services version');
  final _auth = FirebaseAuth.instance;

  const String email = 'joe@gmail.com';
  const String password = 'password';

  // FirebaseApp app = await FirebaseApp.configure(
  //     name: 'Secondary', options: await FirebaseApp.instance.options);

  //      return FirebaseAuth.fromApp(app)
  //     .createUserWithEmailAndPassword(email: email, password: password);

// final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
  await _auth.signInWithEmailAndPassword(email: email, password: password);
  final user = await _auth.currentUser();
// final userAnon = await _auth.signInAnonymously();

  final tokenId = await user.getIdToken(refresh: true);
  final token = tokenId.token;
  final claims = tokenId.claims;

  print('token: ' + token);
  print('claims: ' + claims.toString());

  final bucket = await FirebaseStorage.instance.ref().getBucket();
  print('bucket: ' + bucket.toString());
// var response = await http.get('https://content-storage.googleapis.com/storage/v1/b/$bucket');

// final response = await http.get(
//     'https://content-storage.googleapis.com/storage/v1/b/$bucket/o',
//     headers: {HttpHeaders.authorizationHeader: token},
//   );

  final response = await http
      .get('https://storage.googleapis.com/storage/v1/b/$bucket/o', headers: {
    //       "Accept": "application/json",
    // "Content-type": "application/json",
    "Authorization": "Bearer $token"
  });

// final response = await http.get(
//     'https://content-storage.googleapis.com/storage/v1/b/$bucket/o?access_token=$token');

  print('response: ' + response.statusCode.toString());

  final gapiKey =
      await rootBundle.loadString('assets/text/gapi_service_acct_key.json');
  final _credentials = new ServiceAccountCredentials.fromJson(gapiKey);

// {
//   "private_key_id": ...,
//   "private_key": ...,
//   "client_email": ...,
//   "client_id": ...,
//   "type": "service_account"
// }

  const _SCOPES = const [StorageApi.DevstorageReadOnlyScope];
// final scopes = [storage.StorageApi.DevstorageFullControlScope];
// ...
// var api = new storage.StorageApi(client);

  // clientViaServiceAccount(_credentials, _SCOPES).then((httpClient) {
  //   var storage = new StorageApi(httpClient);
  //   storage.buckets.list('image-manager-3eb96').then((buckets) async {
  //     print("Received ${buckets.items.length} bucket names:");
  //     for (var file in buckets.items) {
  //       print(file.name);
  //     }

  var httpClient = await clientViaServiceAccount(_credentials, _SCOPES);
  var storage = StorageApi(httpClient);
// print("Received ${buckets.items.length} bucket names:");

  final response2 = await httpClient
      .get('https://storage.googleapis.com/storage/v1/b/$bucket/o');

  print('response.statusCode: ' + response2.statusCode.toString());
// print ('response2: '+response2.body.items[0].toString())
// print ('response.body' +json.decode(x.body)['message'])

  if (response2.statusCode == 200) {
    print('successful API return');
    // If the server did return a 200 OK response, then parse the JSON.
    // final data = json.decode(response.body)['items'];
    final data = json.decode(response2.body)['items'];

    print('data: ' + data[1].toString());
    // print('data.items: '+data.items.toString());
    List<Item> items = [];
    // process data in incoming body and export as array of objects
    for (var d in data) {
      print(d['name']);
      //
      // items.add(d);
    }
    return items;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception(
        'Failed to load items. Response Status Code: ${response.statusCode.toString()}');
  }

  //   });
  // });

// await user.getIdToken().then((token) {
//             Map<dynamic,dynamic> tokenMap = token.claims;
//             print('tokenMap: '+tokenMap['sub']);
//           });

// await _auth.signInWithEmailAndPassword(email: email, password: password);

// final getDataVar = await FirebaseStorage.instance.ref().getBucket();
// print (getDataVar);
// var response = await http.get('https://content-storage.googleapis.com/storage/v1/b/$getDataVar');
// print ('response: '+response.statusCode.toString());

// FirebaseOptions

// firebase.auth().currentUser.getIdToken(/* forceRefresh */ true).then(function(idToken) {
//   // Send token to your backend via HTTPS
//   // ...
// }).catch(function(error) {
//   // Handle error
// });

// FirebaseUser mUser = FirebaseAuth.getInstance().getCurrentUser();
// mUser.getIdToken(true)
//     .addOnCompleteListener(new OnCompleteListener<GetTokenResult>() {
//         public void onComplete(@NonNull Task<GetTokenResult> task) {
//             if (task.isSuccessful()) {
//                 String idToken = task.getResult().getToken();
//                 // Send token to your backend via HTTPS
//                 // ...
//             } else {
//                 // Handle error -> task.getException();
//             }
//         }
//     });

  // final response =
  //     await http.get('https://dog.ceo/api/breeds/image/random/$count');

  //     // await http.get('https://content-storage.googleapis.com/storage/v1/b/image-manager-3eb96.appspot.com/o?key=AIzaSyAa8yy0GdcGPHdtD083HiGGx_S0vMPScDM

  // if (response.statusCode == 200) {
  //   print('successful API return');
  //   // If the server did return a 200 OK response, then parse the JSON.
  //   final data = json.decode(response.body)['message'];
  //   List<Item> items = [];
  //   // process data in incoming body and export as array of objects
  //   for (var d in data) {
  //     //
  //     items.add(d);
  //   }
  //   return items;
  // } else {
  //   // If the server did not return a 200 OK response, then throw an exception.
  //   throw Exception(
  //       'Failed to load items. Response Status Code: ${response.statusCode.toString()}');
  // }
}

Future<Item> buildItem(itemName) async {
  // final url = await getItemUrl(itemRef.name);
  // return Item(itemId: 'Bottle20L', itemName: '20 Liter Bottle', imageRef: url);
  print(itemName);
  final url = await getItemUrl(itemName);
  //RegEx after / before . https://stackoverflow.com/a/57186644 and https://stackoverflow.com/a/3671731
  final filenameNoExt =
      RegExp(r"([\w\d_-]*)\.?[^\\\/]*$").firstMatch(itemName).group(1);
  return Item(
      itemId: url,
      itemName: filenameNoExt,
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

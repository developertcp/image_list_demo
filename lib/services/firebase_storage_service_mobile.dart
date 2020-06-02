import 'dart:convert';
import 'dart:io';
// import 'package:path/path.dart' as path;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:googleapis_auth/auth_io.dart';

// class FireStorageService extends ChangeNotifier {
class FireStorageService {
  FireStorageService();

  /// Gets a list of storage files at the given folder
  Future<List<StorageItem>> getStorageItemsAll({String folder = ''}) async {
    List<StorageItem> storageItems = [];
    List<Future> futures = [];
    final gapiKey =
        await rootBundle.loadString('assets/text/gapi_service_acct_key.json');
    final _credentials = new ServiceAccountCredentials.fromJson(gapiKey);
    // const _SCOPES = const [StorageApi.DevstorageReadOnlyScope]; // import 'package:googleapis/storage/v1.dart'; // removing dependency for single object
    const _SCOPES = const [
      "https://www.googleapis.com/auth/devstorage.read_only"
    ];
    final bucket = await FirebaseStorage.instance.ref().getBucket();
    final httpClient = await clientViaServiceAccount(_credentials, _SCOPES);
    // final storage = StorageApi(httpClient);
    final response = await httpClient.get(
        'https://storage.googleapis.com/storage/v1/b/$bucket/o?prefix=$folder'); // ?prefix parameter optional see: https://cloud.google.com/storage/docs/json_api/v1/objects/list
    if (response.statusCode == 200) {
      print('successful API return');
      // If the server did return a 200 OK response, then parse the JSON.
      final resultItems = json.decode(response.body)['items'];
      // process data in incoming body and export as array of objects
      for (var itemRef in resultItems) {
        // .mediaLink and .selfLink returned from cloud storage require further authentication to access. Dropping code in favor or Firebase Storage pattern
        // items.add(Item(
        //     itemId: itemRef['name'],
        //     itemName: path.basenameWithoutExtension(itemRef['name']),
        //     imageRef: itemRef['mediaLink']));
        // items.add(d);
        // print('name: ${itemRef['name']}');
        // print(itemRef.toString());
        // if (path.extension(itemRef['name']) != '') { // if has an extension
        if ((int.tryParse(itemRef['size']) ?? 0 ) > 0) { // if not a folder (size 0 or null or text (evaluates null))
          futures
              .add(buildItem(itemRef['name']).then((x) => storageItems.add(x)));
        }
      }
      await Future.wait(futures);

      return storageItems;
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception(
          'Failed to load storage items. Response Status Code: ${response.statusCode.toString()}');
    }
  }

  Future<StorageItem> buildItem(itemName) async {
    // return Item(itemId: 'Bottle20L', itemName: '20 Liter Bottle', imageRef: url);
    final url = await getItemUrl(itemName);
    //RegEx after / before . https://stackoverflow.com/a/57186644 and https://stackoverflow.com/a/3671731
    final filenameNoExt =
        RegExp(r"([\w\d_-]*)\.?[^\\\/]*$").firstMatch(itemName).group(1);
    return StorageItem(name: filenameNoExt, filename: itemName, url: url);
  }

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

  Future<CloudStorageResult> uploadImage({
    @required File imageToUpload,
    @required String title,
  }) async {
    var imageFileName =
        title + DateTime.now().millisecondsSinceEpoch.toString();

    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(imageFileName);

    StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageToUpload);

    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;

    var downloadUrl = await storageSnapshot.ref.getDownloadURL();

    if (uploadTask.isComplete) {
      var url = downloadUrl.toString();
      return CloudStorageResult(
        imageUrl: url,
        imageFileName: imageFileName,
      );
    }
    return null;
  }
}

class StorageItem {
  final String name;
  final String filename;
  final String url;

  StorageItem({this.name, this.filename, this.url});
}

class StorageItems {
  final List<StorageItem> storageItems;

  StorageItems({this.storageItems});
}

// /// Upload an image to the current Cloud Storage bucket
// class CloudStorageService {
//   Future<CloudStorageResult> uploadImage({
//     @required File imageToUpload,
//     @required String title,
//   }) async {}
// }

class CloudStorageResult {
  final String imageUrl;
  final String imageFileName;

  CloudStorageResult({this.imageUrl, this.imageFileName});
}

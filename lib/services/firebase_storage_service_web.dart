// import 'package:path/path.dart' as path;
import 'package:firebase/firebase.dart';

class FireStorageService {
  FireStorageService();

  Future<List<StorageItem>> getStorageItemsAll({String folder = ''}) async {
    folder = (folder == '' || folder.endsWith('/')) ? folder : '$folder/';
    List<StorageItem> storageItems = [];
    List<Future> futures = [];
    final results = await storage()
        .ref(folder)
        .listAll(); // listAll does not recurse through subfolders
    final resultItems = results.items;
    for (var itemRef in resultItems) {
      // print(itemRef.toString());
      futures.add(
          buildItem(folder + itemRef.name).then((x) => storageItems.add(x)));
    }
    await Future.wait(futures);
    return storageItems;
  }

  Future<StorageItem> buildItem(itemRef) async {
    final url = await getItemUrl(itemRef);
    //RegEx after / before . https://stackoverflow.com/a/57186644 and https://stackoverflow.com/a/3671731
    final filenameNoExt =
        RegExp(r"([\w\d_-]*)\.?[^\\\/]*$").firstMatch(itemRef).group(1);
    return StorageItem(name: filenameNoExt, filename: itemRef, url: url);
  }

  Future<String> getItemUrl(String filename) async {
    // return Future.value(
    //     "https://img.icons8.com/material-sharp/50/000000/delete-link.png");

    try {
      var url = await storage().ref(filename).getDownloadURL();
      return Future.value(url.toString()); // convert URI to explicit string
    } catch (err) {
      print('Error in getDownloadURL for $filename: ' + err.toString());
      return (err.toString());
    }
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

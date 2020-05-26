import 'dart:io';
import 'package:directory_picker/directory_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_list/models/item_model.dart';
import 'package:image_list/services/firebase_storage_service.dart';
import 'package:image_list/services/local_image_pick_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:permission_handler/permission_handler.dart';

class ItemListPage extends StatefulWidget {
  ItemListPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ItemListPageState createState() => _ItemListPageState();
}

enum StorageRoot { internal, external }

class _ItemListPageState extends State<ItemListPage> {
  String sortOrder = '';
  IconData sortArrow = Icons.arrow_drop_down_circle;
  Future<List<Item>> futureItems;
  File _selectedImage;
  String feedback = '';
  Directory selectedDirectory;
  Directory prefPath;
  Directory rootPath;

  @override
  void initState() {
    super.initState();
    _getItemList();
    // futureItems = fetchItemsAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item List App'),
        backgroundColor: Colors.lightBlueAccent,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => _directory_picker(context)),
          // onPressed: _filesystem_picker),
          // onPressed: _file_picker),
          IconButton(
              icon: Icon(this.sortArrow),
              onPressed: () {
                sortToggle(this.sortOrder);
              })
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
              future: futureItems,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Item> items = snapshot.data;
                  items.sort((a, b) => sortBy(a, b)); // alpha sort by breed
                  return Expanded(
                    child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: Hero(
                                tag: 'itemImage_' + items[index].itemId,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage:
                                      FileImage(File(items[index].imageRef)),
                                  // NetworkImage('http://${items[index].imageRef}'),
                                ),
                              ),
                              title: Text(items[index].itemName),
                              subtitle: Text(items[index].imageRef),
                              trailing: Icon(Icons.edit),
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  'ItemDetailPage',
                                  arguments: items[index],
                                );
                              },
                            ),
                          );
                        }),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            ),
            Text(feedback),
            (_selectedImage ==
                    null) // if image is selected from device, show a clickable circle crop
                ? Text('TEST PLACEHOLDER')
                : InkWell(
                    onTap: () {
                      print("image tapped");
                      _upload();
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: FileImage(_selectedImage),
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: _refreshState,
        // onPressed: _getItemList,
        // onPressed: _filesystem_picker,
        // onPressed: () => _directory_picker(context),
        // onPressed: _path_provider,
        // onPressed: _path_provider_ex,
        // onPressed: _permission_handler,
        onPressed: _simpleDialog,
        tooltip: 'PLACEHOLDER',
        child: Icon(Icons.beach_access),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _refreshState() async {
    print("FAB clicked");
    setState(() {});
  }

  void _file_picker() async {
    File file = await FilePicker.getFile();
  }

  Future<void> _setRootPath() async {
    var extStorDirs = await getExternalStorageDirectories();
    if (extStorDirs.length > 1) {
      StorageRoot storageChoice = await _simpleDialog();
      if (storageChoice == StorageRoot.external) {
        // print('external selected');
        prefPath = extStorDirs[1];
        rootPath = Directory(
            RegExp(r'/[^/]*/[^/]*/').firstMatch(extStorDirs[1].toString())[
                0]); // up to third '/' of returned external path
      } else {
        // print('not external');
        prefPath = extStorDirs[0];
        rootPath = Directory(RegExp(r'/[^/]*/[^/]*/[^/]*/')
                .firstMatch(extStorDirs[0].toString())[
            0]); // up to fourth '/' of returned internal path
      }
    }
  }

  void _filesystem_picker() async {
    await _setRootPath();
    // rootPath = await getTemporaryDirectory();
    // rootPath = await getApplicationDocumentsDirectory();
    // rootPath = Directory('/storage/emulated/0');
    // rootPath = Directory('/storage/4221-0000');
    // rootPath = Directory('/storage/emulated/0');

    String path = await FilesystemPicker.open(
      title: 'Select image storage folder',
      context: context,
      rootDirectory: rootPath,
      fsType: FilesystemType.folder,
      pickText: 'Save to this folder',
    );
    setState(() {
      feedback = path;
    });
  }

  void _directory_picker(BuildContext context) async {
    await _setRootPath();
    // Directory directory = selectedDirectory;
    // if (directory == null) {
    //   directory = await getExternalStorageDirectory();
    // }
    Directory directory  = prefPath;

    Directory newDirectory = await DirectoryPicker.pick(
        // allowFolderCreation: true,
        context: context,
        rootDirectory: directory,
        message: 'Permission error accessing filesystem',
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))));

    setState(() {
      selectedDirectory = newDirectory;
      feedback = selectedDirectory != null ? selectedDirectory.path : 'none';
    });
  }

  void _path_provider_ex() async {
    List<StorageInfo> _storageInfo;
    _storageInfo = await PathProviderEx.getStorageInfo();
    print(
        'Internal Storage root:\n ${(_storageInfo.length > 0) ? _storageInfo[0].rootDir : "unavailable"}\n'); // /storage/emulated/0
    print(
        'Internal Storage appFilesDir:\n ${(_storageInfo.length > 0) ? _storageInfo[0].appFilesDir : "unavailable"}\n'); // /storage/emulated/0/Android/data/org.terraclear.image_manager/files
    print(
        'Internal Storage AvailableGB:\n ${(_storageInfo.length > 0) ? _storageInfo[0].availableGB : "unavailable"}\n'); // 1
    print(
        'SD Card root: ${(_storageInfo.length > 1) ? _storageInfo[1].rootDir : "unavailable"}\n'); // /storage/4221-0000
    print(
        'SD Card appFilesDir: ${(_storageInfo.length > 1) ? _storageInfo[1].appFilesDir : "unavailable"}\n'); // /storage/4221-0000/Android/data/org.terraclear.image_manager/files
    print(
        'SD Card AvailableGB:\n ${(_storageInfo.length > 1) ? _storageInfo[1].availableGB : "unavailable"}\n'); //31

    setState(() {
      feedback =
          'SD Card root: ${(_storageInfo.length > 1) ? _storageInfo[1].rootDir : "unavailable"}\n';
    });
  }

  void _image_picker() async {
    // var tempImage = await LocalImagePickService().selectImage('camera');
    var tempImage = await LocalImagePickService().selectImage();
    setState(() {
      _selectedImage = tempImage;
      feedback = tempImage.toString();
    });
  }

  void _path_provider() async {
    Directory tempDir = await getTemporaryDirectory();
    print('tempDir ${tempDir.path}');

    ///data/user/0/org.terraclear.image_manager/cache

    Directory appDocDir = await getApplicationDocumentsDirectory();
    print('appDocDir ${appDocDir.path}');

    ///data/user/0/org.terraclear.image_manager/app_flutter

    Directory extStorDir = await getExternalStorageDirectory();
    print('extStorDir ${extStorDir.path}');

    ///storage/emulated/0/Android/data/org.terraclear.image_manager/files

    var extStorDirs = await getExternalStorageDirectories();
    print(extStorDirs.length); // 2
    print(
        'extStorDirs[0] ${extStorDirs[0]}'); //'/storage/emulated/0/Android/data/org.terraclear.image_manager/files'
    print(
        'extStorDirs[1] ${extStorDirs[1]}'); //'/storage/4221-0000/Android/data/org.terraclear.image_manager/files'

    var extCacheDirs = await getExternalCacheDirectories();
    print(extCacheDirs.length);
    print(
        'extCacheDirs[0] ${extCacheDirs[0]}'); //'/storage/emulated/0/Android/data/org.terraclear.image_manager/cache'
    print(
        'extCacheDirs[1] ${extCacheDirs[1]}'); //'/storage/4221-0000/Android/data/org.terraclear.image_manager/cache'
    setState(() {
      feedback = tempDir.path;
    });
  }

  void _permission_handler() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    print(permissions.toString());

    // var camerastatus = await Permission.camera.status;  // v5.0 not backward compatable
    PermissionStatus camerastatus =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    print('camerastatus: ${camerastatus.toString()}');

    PermissionStatus storageStatus = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    print('storageStatus: ${storageStatus.toString()}');
  }

  void _getItemList() {
    print("FAB clicked");
    setState(() {
      futureItems = getItemsMock();
    });
  }

  Future<StorageRoot> _simpleDialog() async {
    switch (await showDialog<StorageRoot>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Choose Main Storage Location'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, StorageRoot.internal);
                },
                // child: const Text('Device memory'),
                child: ListTile(
                  leading: Icon(Icons.phone_android),
                  title: Text("Device Memory"),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, StorageRoot.external);
                },
                // child: const Text('External SD Card'),
                child: ListTile(
                  leading: Icon(Icons.sd_card),
                  title: Text("External SD Card"),
                ),
              ),
            ],
          );
        })) {
      case StorageRoot.internal:
        return StorageRoot.internal;
        break;
      case StorageRoot.external:
        return StorageRoot.external;
        break;
    }
  }

  void _upload() async {
    final result = await FireStorageService()
        .uploadImage(imageToUpload: _selectedImage, title: "test1");
    setState(() {
      futureItems = fetchItemsAll();
      _selectedImage = null;
    });
  }

  void sortToggle(var currentSort) {
    setState(() {
      if (currentSort == 'ASC') {
        this.sortOrder = "DESC";
        sortArrow = Icons.arrow_upward;
      } else {
        this.sortOrder = "ASC";
        sortArrow = Icons.arrow_downward;
      }
      print(this.sortOrder);
    });
  }

  sortBy(a, b) {
    if (this.sortOrder == 'ASC') {
      return a.itemId.compareTo(b.itemId);
    } else if (this.sortOrder == 'DESC') {
      return b.itemId.compareTo(a.itemId);
    } else {
      return 0;
    }
  }
}

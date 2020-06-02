import 'dart:io';
// import 'dart:io'
// if (dart.library.html) 'dart:html'; // alternate dart:html implementation for web
import 'dart:typed_data';
import 'package:flutter_cache_manager/src/cache_store.dart';
import 'package:flutter_cache_manager/src/storage/cache_object.dart';
import 'package:file/file.dart' as f;
import 'package:pedantic/pedantic.dart';
import 'package:http/http.dart' as http;

// import 'package:directory_picker/directory_picker.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as path;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_list/models/item_model.dart';
import 'package:image_list/services/firebase_storage_service.dart';
import 'package:image_list/services/local_image_pick_service.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:path_provider_ex/path_provider_ex.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:image_list/components/hybrid_image.dart';

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
  dynamic
      _selectedImage; // of type PickedFile from import 'package:image_picker/image_picker.dart';
  String feedback = '';
  Directory selectedDirectory;
  Directory prefPath;
  Directory rootPath;
  CustomCacheManager customCacheManager = CustomCacheManager();

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
              // onPressed: () => _directory_picker(context)),
              // onPressed: _filesystem_picker),
              // onPressed: _file_picker),
              onPressed: _setRootPath),
          IconButton(
              icon: Icon(this.sortArrow),
              onPressed: () {
                sortToggle(this.sortOrder);
              })
        ],
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
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
                              // child: CircleAvatar(
                              //   backgroundColor: Colors.white,
                              //   backgroundImage:
                              //       HybridImage(File(items[index].imageRef)),
                              //   // File(items[index].imageRef).existsSync()
                              //   //     ? FileImage(
                              //   //         File(items[index].imageRef))
                              //   //     : AssetImage('assets/images/001-man-13.png'),
                              //   // NetworkImage(items[index].imageRef),
                              // ),
                              child: CircularNetworkToFileImage(
                                  url: items[index].imageRef,
                                  filepath: items[index].imageRef),
                            ),
                            title: Text(items[index].itemName),
                            // subtitle: Text(items[index].imageRef),
                            subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(items[index].imageRef),
                                  Wrap(spacing: 5, children: [
                                    Icon(Icons.photo_size_select_small,
                                        color: Colors.green),
                                    Icon(Icons.photo_size_select_actual,
                                        color: Colors.green),
                                    Icon(Icons.cloud_done, color: Colors.green)
                                  ]),
//
                                  Row(
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.check_box_outline_blank,
                                          color: Colors.blueGrey,
                                        ),
                                        Text('thumbnail exists')
                                      ]),
                                  Row(children: [
                                    Icon(
                                      Icons.check_box,
                                      color: Colors.blueGrey,
                                    ),
                                    Text('local file exists')
                                  ]),
                                  Row(children: [
                                    Icon(
                                      Icons.check_box_outline_blank,
                                      color: Colors.blueGrey,
                                    ),
                                    Text('server file exists')
                                  ]),
//
                                ]),
                            // trailing: Icon(Icons.edit),
                            trailing: Ink(
                              decoration: ShapeDecoration(
                                color: Colors.lightBlue,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.cloud_upload),
                                color: Colors.white,
                                onPressed: () {
                                  print('IconButton tapped');
                                },
                              ),
                            ),
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
                    // _upload();
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    // backgroundImage: FileImage(_selectedImage),
                    backgroundImage: kIsWeb
                        ? NetworkImage(_selectedImage.path)
                        : FileImage(File(_selectedImage.path)),
                  ),
                ),

          CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkToFileImage(
                  url: 'http://via.placeholder.com/241x250',
                  file: File('/storage/emulated/0/app images/241x250.png'))),

          Image(
            width: 50,
            height: 50,
            image: NetworkToFileImage(
                url: 'https://picsum.photos/250?image=12',
                file: File('/storage/emulated/0/app images/12.png')),
            loadingBuilder: (BuildContext context,
                Widget
                    child, // loading builder delayed until split second once image is loaded, shows in a flash
                ImageChunkEvent loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes
                      : null,
                ),
              );
            },
          ),

          Image(
            width: 50,
            height: 50,
            image: NetworkToFileImage(
                url: 'http://via.placeholder.com/243x250',
                file: File('/storage/emulated/0/app images/243x250.png')),
            frameBuilder: (BuildContext context, Widget child, int frame,
                bool wasSynchronouslyLoaded) {
              // if (wasSynchronouslyLoaded) {
              //   return child;
              // }
              return AnimatedOpacity(
                child: child,
                opacity: frame == null ? 0 : 1,
                duration: const Duration(seconds: 1),
                curve: Curves.easeOut,
              );
            },
          ),

          ClipRRect(
            borderRadius: BorderRadius.circular(25.0),
            clipBehavior: Clip.antiAlias,
            child: Image(
                height: 50.0,
                width: 50.0,
                image: NetworkToFileImage(
                    url: 'https://picsum.photos/250?image=7',
                    file: File('/storage/emulated/0/app images/image7.png'))),
          ),

          // CLOSE SECOND BEST use of NetworkToFileImage (uses progress loader, file first, network second, fade-in, save/cache to folder)
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            clipBehavior: Clip.antiAlias,
            child: Stack(children: <Widget>[
              Container(
                  width: 50.0,
                  height: 50.0,
                  alignment: Alignment.center,
                  // padding: EdgeInsets.all(14.0),
                  child: CircularProgressIndicator()),
              Image(
                height: 50.0,
                width: 50.0,
                image: NetworkToFileImage(
                    url: 'https://picsum.photos/250?image=19',
                    file: File('/storage/emulated/0/app images/image19.png')),
                frameBuilder: (BuildContext context, Widget child, int frame,
                    bool wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) {
                    return child;
                  }
                  return AnimatedOpacity(
                    child: child,
                    opacity: frame == null ? 0 : 1,
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeOut,
                  );
                },
              ),
            ]),
          ),

          // BEST use of NetworkToFileImage (uses progress loader, file first, network second, fade-in, save/cache to folder)
          CircularNetworkToFileImage(
              url: 'https://picsum.photos/250?image=29',
              filepath: 'storage/emulated/0/app images/image29.png',
              placeholderWidget: Image.asset('assets/images/001-man-13.png'),),

          Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Center(child: CircularProgressIndicator()),
              ),
              Center(
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkToFileImage(
                          url: 'https://picsum.photos/250?image=13',
                          file: File(
                              '/storage/emulated/0/app images/image13.png')),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // FutureBuilder tied to http loader provides event based widget loading
          // issues of empty gap between images and intetional sequential loading
          Container(
              decoration: BoxDecoration(shape: BoxShape.circle),
              clipBehavior: Clip.hardEdge,
              width: 50.0,
              height: 50.0,
              child: ImageSequence(
                  loadingWidget: Image.asset('assets/images/001-man-13.png'),
                  imageList: [
                    "https://picsum.photos/250?image=13",
                    "https://picsum.photos/250?image=22",
                    // "https://picsum.photos/250?image=14",
                    // "https://picsum.photos/250?image=15",
                    // "https://picsum.photos/250?image=17",
                    // "https://picsum.photos/250?image=20",
                  ])),

          // Stack(
          //   children: <Widget>[
          //     Padding(
          //       padding: const EdgeInsets.all(2.0),
          //       child: Center(child: CircularProgressIndicator()),
          //     ),
          //     Center(
          //       child: FadeInImage.assetNetwork(
          //         width: 50.0,
          //         height: 50.0,
          //         placeholder: 'assets/images/001-man-13.png',
          //         image: 'https://picsum.photos/250?image=9',
          //         // image: 'http://storage/emulated/0/app images/040-fan.png',
          //       ),
          //     ),
          //   ],
          // ),

          // Container(
          //   width: 50.0,
          //   height: 50.0,
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     image: DecorationImage(
          //       image: NetworkToFileImage(
          //           url: 'http://via.placeholder.com/240x250',
          //           file: File('/storage/emulated/0/app images/240x250.png')),
          //     ),
          //   ),
          // ),

// Image(image: NetworkToFileImage(
//             url: 'https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png',
//             file: File('/storage/emulated/0/app images/flutter-logo.png'))),
// CachedNetworkImage(
//         imageUrl: "http://via.placeholder.com/230x150",
//         placeholder: (context, url) => CircularProgressIndicator(),
//         errorWidget: (context, url, error) => Icon(Icons.error),
//         cacheManager: customCacheManager,
//      ),
// CircleAvatar(
//                     backgroundColor: Colors.white,
//                     // backgroundImage: FileImage(_selectedImage),
//                     backgroundImage: CachedNetworkImageProvider("http://via.placeholder.com/350x150")),

          CachedNetworkImage(
            imageUrl: 'http://via.placeholder.com/150x150',
            imageBuilder: (context, imageProvider) => Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: _refreshState,
        // onPressed: _getItemList,
        // onPressed: _filesystem_picker,
        // onPressed: () => _directory_picker(context),
        // onPressed: _path_provider,
        // onPressed: _path_provider_ex,
        // onPressed: _permission_handler,
        // onPressed: _simpleDialog,
        onPressed: _imagePicker,
        tooltip: 'PLACEHOLDER',
        child: Icon(Icons.beach_access),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _refreshState() async {
    print("FAB clicked");
    setState(() {});
  }

  // void _file_picker() async {
  //   File file = await FilePicker.getFile();
  // }

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
        // default even if clicked outside popup
        // print('not external');
        prefPath = extStorDirs[0];
        rootPath = Directory(RegExp(r'/[^/]*/[^/]*/[^/]*/')
                .firstMatch(extStorDirs[0].toString())[
            0]); // up to fourth '/' of returned internal path
      }
    }
    setState(() {
      feedback = prefPath.toString();
    });
  }

  // void _filesystem_picker() async {
  //   await _setRootPath();
  //   // rootPath = await getTemporaryDirectory();
  //   // rootPath = await getApplicationDocumentsDirectory();
  //   // rootPath = Directory('/storage/emulated/0');
  //   // rootPath = Directory('/storage/4221-0000');
  //   // rootPath = Directory('/storage/emulated/0');

  //   String path = await FilesystemPicker.open(
  //     title: 'Select image storage folder',
  //     context: context,
  //     rootDirectory: rootPath,
  //     fsType: FilesystemType.folder,
  //     pickText: 'Save to this folder',
  //   );
  //   setState(() {
  //     feedback = path;
  //   });
  // }

  // void _directory_picker(BuildContext context) async {
  //   await _setRootPath();
  //   // Directory directory = selectedDirectory;
  //   // if (directory == null) {
  //   //   directory = await getExternalStorageDirectory();
  //   // }
  //   Directory directory  = prefPath;

  //   Directory newDirectory = await DirectoryPicker.pick(
  //       // allowFolderCreation: true,
  //       context: context,
  //       rootDirectory: directory,
  //       message: 'Permission error accessing filesystem',
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(10))));

  //   setState(() {
  //     selectedDirectory = newDirectory;
  //     feedback = selectedDirectory != null ? selectedDirectory.path : 'none';
  //   });
  // }

  // void _path_provider_ex() async {
  //   List<StorageInfo> _storageInfo;
  //   _storageInfo = await PathProviderEx.getStorageInfo();
  //   print(
  //       'Internal Storage root:\n ${(_storageInfo.length > 0) ? _storageInfo[0].rootDir : "unavailable"}\n'); // /storage/emulated/0
  //   print(
  //       'Internal Storage appFilesDir:\n ${(_storageInfo.length > 0) ? _storageInfo[0].appFilesDir : "unavailable"}\n'); // /storage/emulated/0/Android/data/org.terraclear.image_manager/files
  //   print(
  //       'Internal Storage AvailableGB:\n ${(_storageInfo.length > 0) ? _storageInfo[0].availableGB : "unavailable"}\n'); // 1
  //   print(
  //       'SD Card root: ${(_storageInfo.length > 1) ? _storageInfo[1].rootDir : "unavailable"}\n'); // /storage/4221-0000
  //   print(
  //       'SD Card appFilesDir: ${(_storageInfo.length > 1) ? _storageInfo[1].appFilesDir : "unavailable"}\n'); // /storage/4221-0000/Android/data/org.terraclear.image_manager/files
  //   print(
  //       'SD Card AvailableGB:\n ${(_storageInfo.length > 1) ? _storageInfo[1].availableGB : "unavailable"}\n'); //31

  //   setState(() {
  //     feedback =
  //         'SD Card root: ${(_storageInfo.length > 1) ? _storageInfo[1].rootDir : "unavailable"}\n';
  //   });
  // }

  void _imagePicker() async {
    if (prefPath != null) await _setRootPath();
    // var tempImage = await LocalImagePickService().selectImage('camera');
    var tempImage = await LocalImagePickService().selectImage();
    // final String newFilePath = '${prefPath.path}/image_picker_new${DateTime.now().millisecondsSinceEpoch}.png';
    // tempImage.copySync(newFilePath); // copy picked image
    setState(() {
      _selectedImage = tempImage;
      feedback = tempImage.path;
      print(feedback);
    });
    Item newImage = Item(
      itemId: 'New',
      itemName: 'New',
      imageRef: tempImage.path,
      // imageRef: newFilePath,
    );
    _addItem(newImage);
  }

  void _addItem(Item newImage) {
    // setState(() {
    futureItems = Future.value([
      Item(
        itemId: 'CLK15',
        itemName: 'Standard Clock!',
        imageRef: '/storage/emulated/0/app images/015-clock.png',
      ),
      Item(
        itemId: 'TTFAN',
        itemName: 'Non-Adjustable Fan!',
        imageRef: '/storage/emulated/0/app images/040-fan.png',
      ),
      newImage
    ]);
    // });
  }

  // void _path_provider() async {
  //   Directory tempDir = await getTemporaryDirectory();
  //   print('tempDir ${tempDir.path}');

  //   ///data/user/0/org.terraclear.image_manager/cache

  //   Directory appDocDir = await getApplicationDocumentsDirectory();
  //   print('appDocDir ${appDocDir.path}');

  //   ///data/user/0/org.terraclear.image_manager/app_flutter

  //   Directory extStorDir = await getExternalStorageDirectory();
  //   print('extStorDir ${extStorDir.path}');

  //   ///storage/emulated/0/Android/data/org.terraclear.image_manager/files

  //   var extStorDirs = await getExternalStorageDirectories();
  //   print(extStorDirs.length); // 2
  //   print(
  //       'extStorDirs[0] ${extStorDirs[0]}'); //'/storage/emulated/0/Android/data/org.terraclear.image_manager/files'
  //   print(
  //       'extStorDirs[1] ${extStorDirs[1]}'); //'/storage/4221-0000/Android/data/org.terraclear.image_manager/files'

  //   var extCacheDirs = await getExternalCacheDirectories();
  //   print(extCacheDirs.length);
  //   print(
  //       'extCacheDirs[0] ${extCacheDirs[0]}'); //'/storage/emulated/0/Android/data/org.terraclear.image_manager/cache'
  //   print(
  //       'extCacheDirs[1] ${extCacheDirs[1]}'); //'/storage/4221-0000/Android/data/org.terraclear.image_manager/cache'
  //   setState(() {
  //     feedback = tempDir.path;
  //   });
  // }

  // void _permission_handler() async {
  //   Map<PermissionGroup, PermissionStatus> permissions =
  //       await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  //   print(permissions.toString());

  //   // var camerastatus = await Permission.camera.status;  // v5.0 not backward compatable
  //   PermissionStatus camerastatus =
  //       await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
  //   print('camerastatus: ${camerastatus.toString()}');

  //   PermissionStatus storageStatus = await PermissionHandler()
  //       .checkPermissionStatus(PermissionGroup.storage);
  //   print('storageStatus: ${storageStatus.toString()}');
  // }

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
    return StorageRoot.internal; // may only be used for the linter
  }

  // void _upload() async {
  //   final result = await FireStorageService()
  //       .uploadImage(imageToUpload: _selectedImage, title: "test1");
  //   setState(() {
  //     futureItems = fetchItemsAll();
  //     _selectedImage = null;
  //   });
  // }

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

class ImageSequence extends StatelessWidget {
  final Widget loadingWidget;
  final List<String> imageList;

  const ImageSequence({
    this.loadingWidget,
    this.imageList,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('Loading: ${loadingWidget.toString()}');
    return Stack(children: [
      loadingWidget,
      FutureBuilder(
        // Paste your image URL inside the htt.get method as a parameter
        future: http.get(imageList[0]),
        builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            // return loadingWidget; // doesn't help gap between redrawing
            case ConnectionState.active:
            // return loadingWidget;
            case ConnectionState.waiting:
              return loadingWidget ??
                  Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              // when we get the data from the http call, we give the bodyBytes to Image.memory for showing the image
              // print('resolved: ${loadingWidget.toString()}');
              if (imageList.length > 1) {
                // if more than one last image in the list
                imageList.removeAt(0); // pull the current one off the front
                return ImageSequence(
                  // and return another recursive call for the remaining images
                  loadingWidget: Image.memory(snapshot.data
                      .bodyBytes), // loading shows the previous image Byte stream
                  imageList:
                      imageList, // pass the shortened list on to the next iteration
                );
              } else {
                // when the list is down to one image
                return Image.memory(
                    snapshot.data.bodyBytes); // just show the path
              }
          }
          return null; // unreachable
        },
      )
    ]);
  }
}

class CircularNetworkToFileImage extends StatelessWidget {
  final String url;
  final String filepath;
  final double width;
  final double height;
  final Widget placeholderWidget;

  const CircularNetworkToFileImage({
    @required this.url,
    @required this.filepath,
    this.width = 50.0,
    this.height = 50.0,
    this.placeholderWidget,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle),
      clipBehavior: Clip.hardEdge,
      width: width,
      height: height,
      child: Image(
        image: NetworkToFileImage(url: url, file: File(filepath)),
        frameBuilder: (BuildContext context, Widget child, int frame,
            bool wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          // https://medium.com/flutter/improving-perceived-performance-with-image-placeholders-precaching-and-disabled-navigation-6b3601087a2b
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: frame != null // frame 1 is called when image is loaded
                ? child // final widget
                : Stack(children: [ // initial widget
                    placeholderWidget ?? SizedBox(),
                    Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator())
                  ]),
          ); 
        },
      ),
    );
  }
}

class CustomCacheManager extends BaseCacheManager {
  static const key = "customCache";
  CacheStore _store; // for putFile override

  static CustomCacheManager _instance;

  factory CustomCacheManager() {
    if (_instance == null) {
      _instance = new CustomCacheManager._();
    }
    return _instance;
  }

  CustomCacheManager._()
      : super(key,
            maxAgeCacheObject: Duration(days: 700), maxNrOfCacheObjects: 2000);

  Future<String> getFilePath() async {
    // var directory = await getTemporaryDirectory();
    var directory = await getExternalStorageDirectory();
    return path.join(directory.path, key);
  }

  @override
  Future<File> putFile(
    String url,
    Uint8List fileBytes, {
    String eTag,
    Duration maxAge = const Duration(days: 30),
    String fileExtension = 'file',
  }) async {
    var cacheObject = await _store.retrieveCacheData(url);
    cacheObject ??= CacheObject(url, relativePath: '$eTag.$fileExtension');
    cacheObject.validTill = DateTime.now().add(maxAge);
    cacheObject.eTag = eTag;

    Future<f.Directory> _fileDir = _store.fileDir;

    final file = (await _fileDir).childFile(cacheObject.relativePath);
    final folder = file.parent;
    if (!(await folder.exists())) {
      folder.createSync(recursive: true);
    }
    await file.writeAsBytes(fileBytes);
    unawaited(_store.putFile(cacheObject));
    return file;
  }
}

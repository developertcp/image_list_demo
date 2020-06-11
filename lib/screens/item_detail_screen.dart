import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import 'package:image_list/models/item_model.dart';

class ItemDetailScreen extends StatelessWidget {
  final Item item;

  ItemDetailScreen({@required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(item.itemName),
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    // borderRadius: BorderRadius.circular(15.0),
                    child: PhotoView(
                      // https://pub.dev/documentation/photo_view/latest/photo_view/PhotoView-class.html
                      // imageProvider: NetworkImage(item.imageRef),
                      imageProvider: FileImage(File(item.imageRef)),
                      backgroundDecoration: BoxDecoration(color: Colors.white),
                      minScale: PhotoViewComputedScale.contained * 1.0,
                      heroAttributes: PhotoViewHeroAttributes(
                        tag: 'itemImage_${item.itemId}',
                        transitionOnUserGestures: true,
                      ),
                      // enableRotation: true,
                      // basePosition: Alignment.center,
                    ),
                  ),
                ),
                // Image.network(image.imageRef),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    item.itemName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2
                        ..color = Colors.blue[700],
                    ),
                  ),
                ),
                Text(item.itemId),
              ],
            ),
          ),
        ));
  }
}

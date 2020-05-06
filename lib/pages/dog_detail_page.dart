import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import 'package:image_list/models/dog_model.dart';

class DogDetailPage extends StatelessWidget {
  final Dog dog;

  DogDetailPage({@required this.dog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(dog.breed),
        ),
        resizeToAvoidBottomPadding: false,
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
                      imageProvider: NetworkImage(dog.filename),
                      minScale: PhotoViewComputedScale.contained * 1.0,
                      heroAttributes: PhotoViewHeroAttributes(
                        tag: 'dogImage_${dog.breed}',
                        transitionOnUserGestures: true,
                      ),
                      // enableRotation: true,
                      // basePosition: Alignment.center,
                    ),
                  ),
                ),
                // Image.network(dog.filename),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    dog.breed,
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
                Text(dog.filename),
              ],
            ),
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:image_list/routes.dart';

void main() => runApp(ImageList());

class ImageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'DogListPage',
      onGenerateRoute: Routes.generateRoute,
    );
  }
}

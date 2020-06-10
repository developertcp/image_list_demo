import 'package:flutter/material.dart';
import 'package:image_list/locator.dart';
import 'package:image_list/routes.dart';


// void main() {
void main() async {
  try {
    await setupLocator();
    runApp(ImageList());
  } catch(error) {
    print('Locator setup has failed');
  }
  // setupLocator();
  // runApp(ImageList());
}

class ImageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // initialRoute: 'ItemListScreen',
      initialRoute: 'LoginScreen',
      // initialRoute: 'DogListScreen',
      onGenerateRoute: Routes.generateRoute,
    );
  }
}

import 'package:flutter/material.dart';

import 'package:image_list/pages/dog_detail_page.dart';
import 'package:image_list/pages/dog_list_page.dart';

import 'package:image_list/models/dog_model.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      //
      case 'DogListPage':
        return MaterialPageRoute(builder: (_) => DogListPage());
      //
      case 'DogDetailPage':
        // Validation of correct data type
        if (args is Dog) {
          return MaterialPageRoute(
            builder: (_) => DogDetailPage(
              dog: args,
            ),
          );
        }
        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        return _errorRoute(settings);
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute(settings);
    }
  }

  static Route<dynamic> _errorRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ROUTING ERROR: '+settings.toString()),
        ),
      );
    });
  }
}

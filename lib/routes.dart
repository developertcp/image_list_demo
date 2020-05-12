import 'package:flutter/material.dart';

import 'package:image_list/pages/item_list_page.dart';
import 'package:image_list/pages/item_detail_page.dart';

import 'package:image_list/pages/dog_detail_page.dart';
import 'package:image_list/pages/dog_list_page.dart';

import 'package:image_list/models/item_model.dart';
import 'package:image_list/models/dog_model.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      //
      case 'ItemListPage':
        return MaterialPageRoute(builder: (_) => ItemListPage());
      //
      case 'ItemDetailPage':
        // Validation of correct data type
        if (args is Item) {
          // return MaterialPageRoute(
          //   builder: (_) => ItemDetailPage(
          //     dog: args,
          //   )
          // );
          return slideTransition(ItemDetailPage(
            item: args,
          ));
        } // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        return _errorRoute(settings);
      case 'DogListPage':
        return MaterialPageRoute(builder: (_) => DogListPage());
      //
      case 'DogDetailPage':
        // Validation of correct data type
        if (args is Dog) {
          // return MaterialPageRoute(
          //   builder: (_) => DogDetailPage(
          //     dog: args,
          //   )
          // );
          return slideTransition(DogDetailPage(
            dog: args,
          ));
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
          child: Text('ROUTING ERROR: ' + settings.toString()),
        ),
      );
    });
  }

  static slideTransition(page) {
    return PageRouteBuilder(
      //https://medium.com/@agungsurya/create-custom-router-transition-in-flutter-using-pageroutebuilder-73a1a9c4a171
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return page;
      },
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: new Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: new SlideTransition(
            position: new Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(-1.0, 0.0),
            ).animate(secondaryAnimation),
            child: child,
          ),
        );
      },
    );
  }

  static spinFadeTransition(page) {
    return PageRouteBuilder(
        //https://www.raywenderlich.com/4562634-flutter-navigation-getting-started
        opaque: true,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext context, _, __) {
          return page;
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: RotationTransition(
              turns: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
              child: child,
            ),
          );
        });
  }
}

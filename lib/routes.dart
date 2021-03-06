import 'package:flutter/material.dart';

import 'package:image_list/screens/login_screen.dart';
import 'package:image_list/screens/home_screen.dart';
import 'package:image_list/screens/item_list_screen.dart';
import 'package:image_list/screens/item_detail_screen.dart';

import 'package:image_list/screens/dog_detail_screen.dart';
import 'package:image_list/screens/dog_list_screen.dart';

import 'package:image_list/models/item_model.dart';
import 'package:image_list/models/dog_model.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      //
      case 'LoginScreen':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      //
      case 'HomeScreen':
        // if (args is String) {
          return MaterialPageRoute(builder: (_) => HomeScreen(userEmail: args));
        // } // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        // return _errorRoute(settings);
      //
      case 'ItemListScreen':
        return MaterialPageRoute(builder: (_) => ItemListScreen());
      //
      case 'ItemDetailScreen':
        // Validation of correct data type
        if (args is Item) {
          // return MaterialPageRoute(
          //   builder: (_) => ItemDetailScreen(
          //     dog: args,
          //   )
          // );
          return slideTransition(ItemDetailScreen(
            item: args,
          ));
        } // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        return _errorRoute(settings);
      case 'DogListScreen':
        return MaterialPageRoute(builder: (_) => DogListScreen());
      //
      case 'DogDetailScreen':
        // Validation of correct data type
        if (args is Dog) {
          // return MaterialPageRoute(
          //   builder: (_) => DogDetailScreen(
          //     dog: args,
          //   )
          // );
          return slideTransition(DogDetailScreen(
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

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:image_list/models/dog_model.dart';

Future<List<Dog>> apiGetDogsRandom({int count = 1}) async {
  final response =
      await http.get('https://dog.ceo/api/breeds/image/random/$count');

  if (response.statusCode == 200) {
    print('successful API return');
    // If the server did return a 200 OK response, then parse the JSON.
    final data = json.decode(response.body)['message'];
    List<Dog> dogs = [];
    // process data in incoming body and export as array of objects
    for (var d in data) {
      //
      dogs.add(parseBreed(d));
    }
    return dogs;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception(
        'Failed to load dogs. Response Status Code: ${response.statusCode.toString()}');
  }
}

Dog parseBreed(d) {
  RegExp breedExtract = RegExp(r'.*\/([^\/]+)\/'); // regex to match
  String breedUnparsed = breedExtract.firstMatch(d)[1];
  var breedAsWords =
      breedUnparsed.split("-"); // API returns as either breed or breed-subbreed
  var rewordedBreed = '';
  for (var w in breedAsWords) {
    rewordedBreed =
        '${w.toString()[0].toUpperCase()}${w.toString().substring(1)} $rewordedBreed'; // caps to each word
  }
  return Dog(rewordedBreed, d); // breed, filename
}

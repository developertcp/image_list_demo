import 'package:image_list/services/dog_API.dart';

class Dog {
  final String breed;
  final String filename;

  Dog(this.breed, this.filename);
}

Future<Dog> fetchDog() async {
  final response = await apiGetDogsRandom(count: 1);
  return response[0];
}

Future<List<Dog>> fetchDogs({int count = 3}) async {
  return await apiGetDogsRandom(count: count);
}

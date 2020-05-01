import 'dart:convert';
//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dog Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Dog Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String sortOrder = 'ASC';
  IconData sortArrow = Icons.arrow_drop_down_circle;

  void _incrementCounter() {
    setState(() {
      _counter = _counter + 1;
      // futureDog = fetchDog();
      futureDogs = fetchDogs(count: _counter);
      sortArrow = Icons.arrow_drop_down_circle;
    });
  }

  // Future<Dog> futureDog;
  Future<List<Dog>> futureDogs;

  @override
  void initState() {
    super.initState();
    // futureDog = fetchDog();
    futureDogs = fetchDogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: Icon(this.sortArrow),
              onPressed: () {
                sortToggle(this.sortOrder);
              })
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
              future: futureDogs,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Dog> dogs = snapshot.data;
                  dogs.sort((a, b) => sortBy(a, b)); // alpha sort by breed
                  return Expanded(
                    child: ListView.builder(
                        itemCount: dogs.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                backgroundImage:
                                    NetworkImage(dogs[index].filename),
                              ),
                              title: Text(dogs[index].breed),
                              subtitle: Text(dogs[index].filename),
                              trailing: Icon(Icons.edit),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DogDetailPage(dogs[index])));
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
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.beach_access),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  sortToggle(var currentSort) {
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
      return a.breed.compareTo(b.breed);
    } else {
      return b.breed.compareTo(a.breed);
    }
  }
}

// class Album {
//   final int userId;
//   final int id;
//   final String title;

//   Album({this.userId, this.id, this.title});

//   factory Album.fromJson(Map<String, dynamic> json) {
//     return Album(
//       userId: json['userId'],
//       id: json['id'],
//       title: json['title'],
//     );
//   }
// }
class Dog {
  final String breed;
  final String filename;

  Dog(this.breed, this.filename);
}

Future<Dog> fetchDog() async {
  final response =
      await http.get('https://dog.ceo/api/breeds/image/random/300');

  if (response.statusCode == 200) {
    print('successful API return');
    // Album album = Album.fromJson(json.decode(response.body));
    // print(album.title + ' -- ');
    // If the server did return a 200 OK response, then parse the JSON.
    // return album;
    final body = json.decode(response.body);
    final path = body['message'][0];
    RegExp lastFolder = RegExp(r'.*\/([^\/]+)\/'); // regex to match
    final folder = lastFolder.firstMatch(path)[1]; // 1 is first match
    print(json.decode(response.body)['message'][0]);
    print(folder);
    Dog dog = Dog('this breed', folder);
    return dog;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load dog');
  }
}

Future<List<Dog>> fetchDogs({int count = 3}) async {
  final response =
      await http.get('https://dog.ceo/api/breeds/image/random/$count');

  if (response.statusCode == 200) {
    print('successful API return');

    final data = json.decode(response.body)['message'];
    List<Dog> dogs = [];
    RegExp breedExtract = RegExp(r'.*\/([^\/]+)\/'); // regex to match
    for (var d in data) {
      String breedUnparsed = breedExtract.firstMatch(d)[1];
      String breed = parseBreed(breedUnparsed);
      Dog currentDog = Dog(breed, d); // breed, filename
      dogs.add(currentDog);
    }
    // print('dogs: ${dogs.length}');
    return dogs;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load dogs');
  }
}

String parseBreed(breed) {
  var breedAsWords =
      breed.split("-"); // API returns as either breed or breed-subbreed
  var rewordedBreed = '';
  for (var w in breedAsWords) {
    rewordedBreed =
        '${w.toString()[0].toUpperCase()}${w.toString().substring(1)} $rewordedBreed'; // caps to each word
  }
  return rewordedBreed;
}

class DogDetailPage extends StatelessWidget {
  final Dog dog;

  DogDetailPage(this.dog);

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
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: PhotoView(
                    // https://pub.dev/documentation/photo_view/latest/photo_view/PhotoView-class.html
                    imageProvider: NetworkImage(dog.filename),
                    enableRotation: true,
                    basePosition: Alignment.center,
                  ),
                ),
                // SizedBox(
                //   width: MediaQuery.of(context).size.width,
                //   height: MediaQuery.of(context).size.width,
                //   child: PhotoView(
                //     // https://pub.dev/documentation/photo_view/latest/photo_view/PhotoView-class.html
                //     imageProvider: NetworkImage(dog.filename),
                //     enableRotation: true,
                //     basePosition: Alignment.center,
                //   ),
                // ),
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

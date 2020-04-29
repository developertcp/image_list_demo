import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter = _counter + 2;
      futureDog = fetchDog();
      futureDogs = fetchDogs(count: _counter);
    });
  }

  // Future<Album> futureAlbum;
  // @override
  // void initState() {
  //   super.initState();
  //   futureAlbum = fetchAlbum();
  // }

  Future<Dog> futureDog;
  Future<List<Dog>> futureDogs;
  @override
  void initState() {
    super.initState();
    futureDog = fetchDog();
    futureDogs = fetchDogs();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
              future: futureDog,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data.filename);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            ),
            FutureBuilder(
              future: futureDogs,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(backgroundColor: Colors.blueAccent,
                              backgroundImage: NetworkImage(snapshot.data[index].filename),),

                              title: Text(snapshot.data[index].breed),
                              subtitle: Text(snapshot.data[index].filename),
                              trailing: Icon(Icons.edit),
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
            Expanded(
              child: ListView(children: <Widget>[
                Card(
                  child: ListTile(
                    leading: Image.asset('assets/images/001-man-13.png'),
                    title: Text("Joe Manrow (m30)."),
                    subtitle: Text("coolest haircut in town"),
                    trailing: Icon(Icons.edit),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Image.asset('assets/images/001-man-13.png'),
                    title: Text("Joe Manrow (m30)."),
                    subtitle: Text("coolest haircut in town"),
                    trailing: Icon(Icons.edit),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Image.asset('assets/images/001-man-13.png'),
                    title: Text("Joe Manrow (m30)."),
                    subtitle: Text("coolest haircut in town"),
                    trailing: Icon(Icons.edit),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Image.asset('assets/images/001-man-13.png'),
                    title: Text("Joe Manrow (m30)."),
                    subtitle: Text("coolest haircut in town"),
                    trailing: Icon(Icons.edit),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Image.asset('assets/images/001-man-13.png'),
                    title: Text("Joe Manrow (m30)."),
                    subtitle: Text("coolest haircut in town"),
                    trailing: Icon(Icons.edit),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Image.asset('assets/images/001-man-13.png'),
                    title: Text("Joe Manrow (m30)."),
                    subtitle: Text("coolest haircut in town"),
                    trailing: Icon(Icons.edit),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Image.asset('assets/images/001-man-13.png'),
                    title: Text("Joe Manrow (m30)."),
                    subtitle: Text("coolest haircut in town"),
                    trailing: Icon(Icons.edit),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Image.asset('assets/images/001-man-13.png'),
                    title: Text("Joe Manrow (m30)."),
                    subtitle: Text("coolest haircut in town"),
                    trailing: Icon(Icons.edit),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Image.asset('assets/images/001-man-13.png'),
                    title: Text("Joe Manrow (m30)."),
                    subtitle: Text("coolest haircut in town"),
                    trailing: Icon(Icons.edit),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Image.asset('assets/images/001-man-13.png'),
                    title: Text("Joe Manrow (m30)."),
                    subtitle: Text("coolest haircut in town"),
                    trailing: Icon(Icons.edit),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Image.asset('assets/images/001-man-13.png'),
                    title: Text("Joe Manrow (m30)."),
                    subtitle: Text("coolest haircut in town"),
                    trailing: Icon(Icons.edit),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Image.asset('assets/images/001-man-13.png'),
                    title: Text("Joe Manrow (m30)."),
                    subtitle: Text("coolest haircut in town"),
                    trailing: Icon(Icons.edit),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Image.asset('assets/images/001-man-13.png'),
                    title: Text("Joe Manrow (m30)."),
                    subtitle: Text("coolest haircut in town"),
                    trailing: Icon(Icons.edit),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Image.asset('assets/images/001-man-13.png'),
                    title: Text("Joe Manrow (m30)."),
                    subtitle: Text("coolest haircut in town"),
                    trailing: Icon(Icons.edit),
                  ),
                ),
              ]),
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
}

// Future<http.Response> fetchAlbum() {
//   return http.get('https://jsonplaceholder.typicode.com/albums/1');
// }

Future<Album> fetchAlbum() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/albums/1');

  if (response.statusCode == 200) {
    print('successful API return');
    Album album = Album.fromJson(json.decode(response.body));
    print(album.title + ' -- ');
    // If the server did return a 200 OK response, then parse the JSON.
    return album;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({this.userId, this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
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
      await http.get('https://dog.ceo/api/breeds/image/random/${count}');

  if (response.statusCode == 200) {
    print('successful API return');

    final data = json.decode(response.body)['message'];
    List<Dog> dogs = [];
    RegExp breedExtract = RegExp(r'.*\/([^\/]+)\/'); // regex to match
    for (var d in data) {
      final breed = breedExtract.firstMatch(d)[1];
      Dog currentDog = Dog(breed, d); // breed, filename
      dogs.add(currentDog);
    }

    print('dogs: ${dogs.length}');

    return dogs;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load dogs');
  }
}

class Dog {
  final String breed;
  final String filename;

  Dog(this.breed, this.filename);
}

import 'package:flutter/material.dart';
import 'package:image_list/models/dog_model.dart';
import 'package:image_list/components/sorted_dog_list.dart';

class DogListPage extends StatefulWidget {
  DogListPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _DogListPageState createState() => _DogListPageState();
}

class _DogListPageState extends State<DogListPage> {
  int _counter = 0;
  String sortOrder = '';
  IconData sortArrow = Icons.arrow_drop_down_circle;
  Future<List<Dog>> futureDogs;

  @override
  void initState() {
    super.initState();
    futureDogs = fetchDogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dog Days Finderouter App'),
        backgroundColor: Colors.lightBlueAccent,
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
                  return SortedDogList(dogs: dogs);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            ),
            Text(
              (_counter > 10)
                  ? 'Whoa doggie, You have added $_counter dogs to your list:'
                  : 'You have added $_counter dogs to your list:',
            ),
            Text(
              '$_counter',
              // style: Theme.of(context).textTheme.display1,
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

  void _incrementCounter() {
    setState(() {
      _counter = _counter + 1;
      futureDogs = fetchDogs(count: _counter);
      sortArrow = Icons.arrow_drop_down_circle; // revert to unsorted
      sortOrder = '';
    });
  }

  void sortToggle(var currentSort) {
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
    } else if (this.sortOrder == 'DESC') {
      return b.breed.compareTo(a.breed);
    } else {
      return 0;
    }
  }
}



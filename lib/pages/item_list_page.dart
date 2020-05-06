import 'package:flutter/material.dart';
import 'package:image_list/models/item_model.dart';

//temp
// import 'package:image_list/services/firebase_storage_service.dart';

class ItemListPage extends StatefulWidget {
  ItemListPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ItemListPageState createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  // int _counter = 0;
  String sortOrder = '';
  IconData sortArrow = Icons.arrow_drop_down_circle;
  Future<List<Item>> futureItems;

  @override
  void initState() {
    super.initState();
    futureItems = fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item List App'),
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
              future: futureItems,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Item> items = snapshot.data;
                  items.sort((a, b) => sortBy(a, b)); // alpha sort by breed
                  return Expanded(
                    child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: Hero(
                                tag: 'itemImage_' + items[index].itemId,
                                child: CircleAvatar(
                                  backgroundColor: Colors.blueAccent,
                                  backgroundImage:
                                      NetworkImage(items[index].imageRef),
                                ),
                              ),
                              title: Text(items[index].itemName),
                              subtitle: Text(items[index].imageRef),
                              trailing: Icon(Icons.edit),
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  'ItemDetailPage',
                                  arguments: items[index],
                                );
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

//  FutureBuilder(
//                             // future: getItemUrl('Bottle20L.png'),
//                             future: getImage(context, 'Bottle20L.png'),
//                             builder: (context, snapshot) {
//                               if (snapshot.connectionState ==
//                                   ConnectionState.done)
//                                 return Container(
//                                   height:
//                                       MediaQuery.of(context).size.height / 1.25,
//                                   width:
//                                       MediaQuery.of(context).size.width / 1.25,
//                                   child: snapshot.data,
//                                 );

//                               if (snapshot.connectionState ==
//                                   ConnectionState.waiting)
//                                 return Container(
//                                     height: MediaQuery.of(context).size.height /
//                                         1.25,
//                                     width: MediaQuery.of(context).size.width /
//                                         1.25,
//                                     child: CircularProgressIndicator());

//                               return Container();
//                             },
//  ),

//
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshState,
        tooltip: 'PLACEHOLDER',
        child: Icon(Icons.beach_access),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // Future<Widget> _getImage(BuildContext context, String image) async {
  //   Image m;
  //   await FirebaseStorageService.loadFromStorage(context, image)
  //       .then((downloadUrl) {
  //     m = Image.network(
  //       downloadUrl.toString(),
  //       fit: BoxFit.scaleDown,
  //     );
  //   });

  //   return m;
  // }

  void _refreshState() {
    print("FAB clicked");
    futureItems = fetchItems();
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
      return a.itemId.compareTo(b.itemId);
    } else if (this.sortOrder == 'DESC') {
      return b.itemId.compareTo(a.itemId);
    } else {
      return 0;
    }
  }
}

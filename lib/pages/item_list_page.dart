import 'package:flutter/material.dart';
import 'package:image_list/models/item_model.dart';

class ItemListPage extends StatefulWidget {
  ItemListPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ItemListPageState createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  String sortOrder = '';
  IconData sortArrow = Icons.arrow_drop_down_circle;
  Future<List<Item>> futureItems;

  @override
  void initState() {
    super.initState();
    futureItems = fetchItemsAll();
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
                                  backgroundColor: Colors.white,
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

  void _refreshState() {
    print("FAB clicked");
    setState(() {});
    setState(() {
    futureItems = fetchItemsAll();
    // apiGetAllItems();
    // getItemsAll();
    // getItemUrl('test/009-airport.png');
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
      return a.itemId.compareTo(b.itemId);
    } else if (this.sortOrder == 'DESC') {
      return b.itemId.compareTo(a.itemId);
    } else {
      return 0;
    }
  }
}

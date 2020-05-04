import 'package:flutter/material.dart';
import 'package:image_list/models/dog_model.dart';

class SortedDogList extends StatelessWidget {
  const SortedDogList({
    Key key,
    @required this.dogs,
  }) : super(key: key);

  final List<Dog> dogs;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: dogs.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: Hero(
                  tag: 'dogImage_' + dogs[index].breed,
                  child: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    backgroundImage:
                        NetworkImage(dogs[index].filename),
                  ),
                ),
                title: Text(dogs[index].breed),
                subtitle: Text(dogs[index].filename),
                trailing: Icon(Icons.edit),
                onTap: () {
                  Navigator.of(context).pushNamed('DogDetailPage',
                      arguments: dogs[index],);
                },
              ),
            );
          }),
    );
  }
}
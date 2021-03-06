import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/great_places.dart';

import '../screens/add_place_screen.dart';
import '../screens/place_detail_screen.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Places'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (context, snapshot) => Consumer<GreatPlaces>(
          builder: (ctx, greatPlaces, ch) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : (greatPlaces.items.isEmpty
                  ? ch
                  : ListView.builder(
                      itemCount: greatPlaces.items.length,
                      itemBuilder: (ctx, i) => ListTile(
                        leading: CircleAvatar(
                          backgroundImage: FileImage(
                            greatPlaces.items[i].image,
                          ),
                        ),
                        title: Text(greatPlaces.items[i].title),
                        subtitle: Text(
                            greatPlaces.items[i].location.address.toString()),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            PlaceDetailScreen.routeName,
                            arguments: greatPlaces.items[i].id,
                          );
                        },
                      ),
                    )) as Widget,
          child: const Center(
            child: Text('Got no places yet, start addimg some!'),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/screens/map_screen.dart';
import 'package:location/location.dart';

import '../helper/location_helper.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;

  const LocationInput(this.onSelectPlace, {Key? key}) : super(key: key);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _prevImageUrl;

  void _showPreview(double lat, double lng) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );
    setState(() {
      _prevImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      final locData = await Location().getLocation();
      _showPreview(locData.latitude as double, locData.longitude as double);
      widget.onSelectPlace(locData.latitude, locData.longitude);
      // print(locData.latitude);
      // print(locData.longitude);
    } catch (error) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
    print(selectedLocation.latitude);
    print(selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _prevImageUrl == null
              ? const Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _prevImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Current Location'),
              style: ElevatedButton.styleFrom(
                // primary: Theme.of(context).colorScheme.primary,
                onPrimary: Theme.of(context).colorScheme.primary,
              ),
              onPressed: _getCurrentLocation,
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
              style: ElevatedButton.styleFrom(
                // primary: Theme.of(context).colorScheme.primary,
                onPrimary: Theme.of(context).colorScheme.primary,
              ),
              onPressed: _selectOnMap,
            )
          ],
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChooseLocationMap extends StatefulWidget {
  const ChooseLocationMap({
    super.key,
  });

  @override
  State<ChooseLocationMap> createState() => _ChooseLocationMapState();
}

class _ChooseLocationMapState extends State<ChooseLocationMap> {
  LatLng? _pickedLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick your Business Location'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: GoogleMap(
        onTap: (position) {
          setState(() {
            _pickedLocation = position;
          });
        },
        initialCameraPosition: const CameraPosition(
          zoom: 16,
          target: LatLng(37.948814, 23.722998),
        ),
        markers: _pickedLocation == null
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('m1'),
                  position:
                      _pickedLocation ?? const LatLng(37.948814, 23.722998),
                )
              },
      ),
    );
  }
}

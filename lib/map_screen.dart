import 'dart:io';

import 'package:dyatel_app/home_screen.dart';
import 'package:dyatel_app/report_model.dart';
import 'package:dyatel_app/services/Utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import 'services/DatabaseHandler.dart';

class MapScreen extends StatefulWidget {
  // MapScreen({Key key}) : super(key: key);
  final File image;
  final Text description;

  MapScreen({File image, Text description})
      : this.image = image,
        this.description = description;

  @override
  _MapScreenState createState() =>
      _MapScreenState(image: this.image, description: this.description);
}

class _MapScreenState extends State<MapScreen> {
  final DatabaseHandler handler;

  final File image;
  final Text description;

  _MapScreenState({File image, Text description})
      : this.image = image,
        this.description = description,
        this.handler = DatabaseHandler() {
    this.handler.initializeDB();
  }

  final MapController mapController = MapController(
    initMapWithUserPosition: true,
    initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
  );

  ValueNotifier<bool> advPickerNotifierActivation = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Position'),
        backgroundColor: Colors.amber[800],
        actions: [
          IconButton(
              onPressed: () async {
                await mapController.currentLocation();
                await mapController.zoom(5.0);
              },
              icon: Icon(Icons.my_location)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (advPickerNotifierActivation.value == false) {
              advPickerNotifierActivation.value = true;
              await mapController.advancedPositionPicker();
            }
          },
          child: Icon(Icons.select_all)),
      body: Container(
          child: Stack(
        children: [
          OSMFlutter(
              controller: mapController,
              defaultZoom: 3.0,
              markerIcon: MarkerIcon(
                icon: Icon(
                  Icons.person_pin_circle,
                  color: Colors.amber[800],
                  size: 56,
                ),
              )),
          Positioned(
            bottom: 10,
            left: 10,
            child: ValueListenableBuilder<bool>(
              valueListenable: advPickerNotifierActivation,
              builder: (ctx, visible, child) {
                return Visibility(
                  visible: visible,
                  child: AnimatedOpacity(
                    opacity: visible ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: child,
                  ),
                );
              },
              child: FloatingActionButton(
                key: UniqueKey(),
                child: Icon(Icons.arrow_forward),
                heroTag: "confirmAdvPicker",
                onPressed: () async {
                  advPickerNotifierActivation.value = false;
                  GeoPoint p =
                      await mapController.selectAdvancedPositionPicker();

                  Report report = Report(
                      description: this.description.data,
                      image: Utility.base64String(image.readAsBytesSync()),
                      longitude: p.longitude,
                      latitude: p.latitude);

                  int result = 0;
                  try {
                    int result = await this.handler.insertReport(report);
                  } catch (err) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error during saving to DB')));
                  }

                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                    builder: (context) {
                      return HomeScreen();
                    },
                  ), (route) => false);
                  if (result == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Incident saved to DB')));
                  } else {
                    SnackBar(content: Text('Some error during saving to DB'));
                  }
                },
              ),
            ),
          ),
        ],
      )),
    );
  }
}

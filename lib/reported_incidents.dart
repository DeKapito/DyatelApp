import 'dart:io';

import 'package:dyatel_app/home_screen.dart';
import 'package:dyatel_app/report_model.dart';
import 'package:dyatel_app/services/Utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import 'services/DatabaseHandler.dart';

class ReportedIncidents extends StatefulWidget {
  @override
  _ReportedIncidentsState createState() => _ReportedIncidentsState();
}

class _ReportedIncidentsState extends State<ReportedIncidents> {
  final DatabaseHandler handler;
  Future<List<Report>> items;

  _ReportedIncidentsState() : this.handler = DatabaseHandler() {
    this.handler.initializeDB();
  }

  Future<List<Report>> fetchReports() async {
    try {
      return await handler.retrieveReports();
    } catch (err) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    items = handler.retrieveReports();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: items,
      builder: (context, snapshot) {
        // operation for completed state
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                Report item = snapshot.data[index];
                var longitude = item.longitude;
                var latitude = item.latitude;
                return ListTile(
                  title: Text(item.description),
                  subtitle: Text('Coords: [$longitude, $latitude}]'),
                  leading: Container(
                      width: 50,
                      child: Utility.imageFromBase64String(item.image)),
                );
              });
        }

        // spinner for uncompleted state
        return Center(
          child: Container(
              alignment: AlignmentDirectional.bottomCenter,
              child: Column(
                children: <Widget>[
                  CircularProgressIndicator(),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
              )),
        );
      },
    );
  }
}

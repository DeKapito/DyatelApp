import 'dart:io';

import 'package:dyatel_app/map_screen.dart';
import 'package:flutter/material.dart';

class ReportIncident extends StatelessWidget {
  final File image;

  final textController = TextEditingController();

  ReportIncident({File image}) : this.image = image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Report Incident'),
          backgroundColor: Colors.amber[800],
        ),
        // body: Center(child: image),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 250),
                child: Image.file(image),
              ),
            ),
            // image,
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: TextField(
                maxLines: 6,
                controller: textController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a description of incident'),
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.amber[800])),
                    child: Text('Next Step'),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return MapScreen(
                              image: image,
                              description: Text(textController.text),
                            );
                          },
                        ),
                      );
                    },
                  )),
            )
          ],
        ));
  }
}

import 'package:dyatel_app/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddImage extends StatelessWidget {
  final picker = ImagePicker();

  Future _getImageFromCamera() async {
    final PickedFile pickedFile =
        await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
  }

  Future _getImageFromGallery() async {
    final PickedFile pickedFile =
        await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      print(File(pickedFile.path).path);
      return File(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: Ink(
          decoration: ShapeDecoration(
            color: Colors.amber[800],
            shape: CircleBorder(),
          ),
          child: IconButton(
            iconSize: 200.0,
            icon: const Icon(Icons.photo_camera),
            color: Colors.white,
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext bc) {
                    return SafeArea(
                      child: Container(
                        child: new Wrap(
                          children: <Widget>[
                            new ListTile(
                              leading: new Icon(Icons.photo_camera),
                              title: new Text('Use Camera'),
                              onTap: () async {
                                print("Clicked Camera");
                                var pickedImage = await _getImageFromCamera();
                                if (pickedImage == null) {
                                  Navigator.of(context).pop;
                                  return;
                                }
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ReportIncident(image: pickedImage);
                                    },
                                  ),
                                );
                              },
                            ),
                            new ListTile(
                              leading: new Icon(Icons.photo_library),
                              title: new Text('Upload from Gallery'),
                              onTap: () async {
                                print("Clicked Gallery");
                                var pickedImage = await _getImageFromGallery();
                                if (pickedImage == null) {
                                  Navigator.of(context).pop;
                                  return;
                                }
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ReportIncident(image: pickedImage);
                                    },
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  });
            },
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as ui;
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File _originalImage;
  File _watermarkImage;
  File _watermarkedImage;
  final picker = ImagePicker();

  Future getOriginalImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _originalImage = File(pickedFile.path);
    });
  }

  Future getWatermarkImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _watermarkImage = File(pickedFile.path);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Watermark Example"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
//<--------------- select original image ---------------->
              _originalImage == null
                  ? FlatButton(
                      child: Text("Select Original Image"),
                      onPressed: getOriginalImage,
                    )
                  : Image.file(_originalImage),

//<--------------- select watermark image ---------------->
              _watermarkImage == null
                  ? FlatButton(
                      child: Text("Select Watermark Image"),
                      onPressed: getWatermarkImage,
                    )
                  : Image.file(_watermarkImage),

              SizedBox(
                height: 50,
              ),
//<--------------- apply watermark over image ---------------->
              (_originalImage != null) && (_watermarkImage != null)
                  ? FlatButton(
                      child: Text("Apply Watermark Over Image"),
                      onPressed: () async {
                        ui.Image originalImage = ui.decodeImage(_originalImage.readAsBytesSync());
                        ui.Image watermarkImage = ui.decodeImage(_watermarkImage.readAsBytesSync());

                        // add watermark over originalImage
                        // initialize width and height of watermark image
                        ui.Image image = ui.Image(160, 50);
                        ui.drawImage(image, watermarkImage);

                        // give position to watermark over image
                        // originalImage.width - 160 - 25 (width of originalImage - width of watermarkImage - extra margin you want to give)
                        // originalImage.height - 50 - 25 (height of originalImage - height of watermarkImage - extra margin you want to give)
                        ui.copyInto(originalImage, image,
                            dstX: originalImage.width - 160 - 25,
                            dstY: originalImage.height - 50 - 25);

                        // for adding text over image
                        // Draw some text using 24pt arial font
                        // 100 is position from x-axis, 120 is position from y-axis
                        ui.drawString(originalImage, ui.arial_24, 100, 120, 'Think Different');

                        // Store the watermarked image to a File
                        List<int> wmImage = ui.encodePng(originalImage);
                        setState(() {
                          _watermarkedImage = File.fromRawPath(Uint8List.fromList(wmImage));
                        });
                      },
                    )
                  : Container(),

//<--------------- display watermarked image ---------------->
              _watermarkedImage != null ? Image.file(_watermarkedImage) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

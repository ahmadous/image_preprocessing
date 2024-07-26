import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';
import '../providers/image_processor_provider.dart';

class ImagePage extends StatefulWidget {
  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        final imageProcessorProvider =
            Provider.of<ImageProcessorProvider>(context, listen: false);
        final decodedImage = img.decodeImage(_image!.readAsBytesSync());
        if (decodedImage != null) {
          imageProcessorProvider.setImage(decodedImage);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Processing'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<ImageProcessorProvider>(
                builder: (context, imageProcessor, child) {
                  return imageProcessor.processedImage == null
                      ? Text('No image selected.')
                      : Image.memory(Uint8List.fromList(
                          img.encodeJpg(imageProcessor.processedImage!)));
                },
              ),
              ElevatedButton(
                onPressed: () => _pickImage(context, ImageSource.camera),
                child: Text('Take Photo'),
              ),
              ElevatedButton(
                onPressed: () => _pickImage(context, ImageSource.gallery),
                child: Text('Select from Gallery'),
              ),
              Consumer<ImageProcessorProvider>(
                builder: (context, imageProcessor, child) {
                  return imageProcessor.processedImage != null
                      ? Column(
                          children: [
                            ElevatedButton(
                              onPressed: imageProcessor.applyHistogram,
                              child: Text('Apply Histogram'),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  imageProcessor.applyContrast(1.5),
                              child: Text('Increase Contrast'),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  imageProcessor.applyContrast(0.5),
                              child: Text('Decrease Contrast'),
                            ),
                          ],
                        )
                      : Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

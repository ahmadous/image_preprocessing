import 'package:computer_vision/features/image_processing/presentation/providers/image_processor_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';

class ImageSelectionPage extends StatefulWidget {
  @override
  _ImageSelectionPageState createState() => _ImageSelectionPageState();
}

class _ImageSelectionPageState extends State<ImageSelectionPage> {
  final picker = ImagePicker();

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final permissionStatus = await _requestPermission(source);
    if (permissionStatus != PermissionStatus.granted) {
      return;
    }

    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final imageProcessorProvider =
          Provider.of<ImageProcessorProvider>(context, listen: false);
      final bytes = await pickedFile.readAsBytes();
      final decodedImage = img.decodeImage(bytes);
      if (decodedImage != null) {
        imageProcessorProvider.setImage(decodedImage);
        Navigator.pop(
            context); // Retourne à la page précédente après la sélection
      }
    }
  }

  Future<PermissionStatus> _requestPermission(ImageSource source) async {
    if (source == ImageSource.camera) {
      return await Permission.camera.request();
    } else {
      return await Permission.photos.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Image Source'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _pickImage(context, ImageSource.camera),
              child: Text('Take Photo'),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(context, ImageSource.gallery),
              child: Text('Select from Gallery'),
            ),
          ],
        ),
      ),
    );
  }
}

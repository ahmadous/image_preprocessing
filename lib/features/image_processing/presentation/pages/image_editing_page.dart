import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;
import 'package:share/share.dart';
import '../providers/image_processor_provider.dart';
import '../widgets/resize_dialog.dart';

class ImageEditingPage extends StatefulWidget {
  @override
  _ImageEditingPageState createState() => _ImageEditingPageState();
}

class _ImageEditingPageState extends State<ImageEditingPage> {
  double _contrastValue = 1.0;
  int _brightnessValue = 0;
  double _saturationValue = 1.0;
  double _hueValue = 0.0;
  bool _showOriginal = false;

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _applyAdjustments(ImageProcessorProvider imageProcessor) {
    imageProcessor.resetToOriginal();
    imageProcessor.applyContrast(_contrastValue);
    imageProcessor.applyBrightness(_brightnessValue);
    imageProcessor.applySaturation(_saturationValue);
    imageProcessor.applyHue(_hueValue);
  }

  Uint8List? imageToUint8List(img.Image? image) {
    if (image == null) return null;
    return Uint8List.fromList(img.encodeJpg(image));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier l\'image'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async {
              final imageProcessor =
                  Provider.of<ImageProcessorProvider>(context, listen: false);
              final filePath = await imageProcessor.saveImage(true);

              if (filePath.isNotEmpty) {
                Share.shareFiles([filePath], text: 'Voici une image modifiée!');
              } else {
                showSnackBar(context, 'Aucune image à partager');
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              final imageProcessor =
                  Provider.of<ImageProcessorProvider>(context, listen: false);
              String message = await imageProcessor.saveImage(true);
              showSnackBar(context, message);
            },
          ),
          IconButton(
            icon: Icon(Icons.restore),
            onPressed: () {
              final imageProcessor =
                  Provider.of<ImageProcessorProvider>(context, listen: false);
              imageProcessor.resetImage();
              showSnackBar(context, 'Image réinitialisée');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Consumer<ImageProcessorProvider>(
          builder: (context, imageProcessor, child) {
            final imageBytes = imageToUint8List(
              _showOriginal
                  ? imageProcessor.originalImage
                  : imageProcessor.processedImage,
            );

            return imageProcessor.originalImage == null
                ? Center(child: Text('Aucune image sélectionnée.'))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: imageBytes != null
                            ? Image.memory(
                                imageBytes,
                                height: 200,
                                fit: BoxFit.contain,
                              )
                            : Container(
                                height: 200,
                                color: Colors.grey,
                                child: Center(child: Text('Image non chargée')),
                              ),
                      ),
                      SwitchListTile(
                        title: Text('Afficher l\'image originale'),
                        value: _showOriginal,
                        onChanged: (value) {
                          setState(() {
                            _showOriginal = value;
                          });
                        },
                      ),
                      _buildAdjustmentButtons(context, imageProcessor),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                imageProcessor.undo();
                              },
                              icon: Icon(Icons.undo),
                              label: Text('Annuler'),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton.icon(
                              onPressed: () {
                                imageProcessor.redo();
                              },
                              icon: Icon(Icons.redo),
                              label: Text('Rétablir'),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Filtres',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: [
                          FilterButton(
                            onPressed: () {
                              setState(() {
                                imageProcessor.applyHistogram();
                              });
                            },
                            label: 'Histogramme',
                            icon: Icons.equalizer,
                          ),
                          FilterButton(
                            onPressed: () {
                              setState(() {
                                imageProcessor.applySmoothing();
                              });
                            },
                            label: 'Lissage',
                            icon: Icons.blur_on,
                          ),
                          FilterButton(
                            onPressed: () {
                              setState(() {
                                imageProcessor.applyEdgeDetection();
                              });
                            },
                            label: 'Contours',
                            icon: Icons.border_outer,
                          ),
                          FilterButton(
                            onPressed: () {
                              setState(() {
                                imageProcessor.applyRotation(90);
                              });
                            },
                            label: 'Tourner 90°',
                            icon: Icons.rotate_right,
                          ),
                          FilterButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => ResizeDialog(
                                  onResize: (largeur, hauteur) {
                                    setState(() {
                                      imageProcessor.applyResize(
                                          largeur, hauteur);
                                    });
                                  },
                                ),
                              );
                            },
                            label: 'Redimensionner',
                            icon: Icons.photo_size_select_large,
                          ),
                          FilterButton(
                            onPressed: () {
                              setState(() {
                                imageProcessor.applySharpen();
                              });
                            },
                            label: 'Renforcement',
                            icon: Icons.filter_hdr,
                          ),
                          FilterButton(
                            onPressed: () {
                              setState(() {
                                imageProcessor.applyLaplacianEdgeDetection();
                              });
                            },
                            label: 'Contours Laplacian',
                            icon: Icons.grain,
                          ),
                        ],
                      ),
                    ],
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final imageProcessor =
              Provider.of<ImageProcessorProvider>(context, listen: false);
          await imageProcessor.requestPermissions();
          showModalBottomSheet(
            context: context,
            builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Choisir depuis la galerie'),
                  onTap: () {
                    imageProcessor.pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Prendre une photo'),
                  onTap: () {
                    imageProcessor.pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add_a_photo),
        backgroundColor: Colors.teal,
      ),
    );
  }

  Widget _buildAdjustmentButtons(
      BuildContext context, ImageProcessorProvider imageProcessor) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _buildAdjustmentRow(
            context,
            'Contraste',
            Icons.contrast,
            () {
              setState(() {
                _contrastValue += 0.1;
                if (_contrastValue > 2.0) _contrastValue = 2.0;
                _applyAdjustments(imageProcessor);
              });
            },
            () {
              setState(() {
                _contrastValue -= 0.1;
                if (_contrastValue < 0.5) _contrastValue = 0.5;
                _applyAdjustments(imageProcessor);
              });
            },
          ),
          _buildAdjustmentRow(
            context,
            'Luminosité',
            Icons.brightness_6,
            () {
              setState(() {
                _brightnessValue += 10;
                if (_brightnessValue > 100) _brightnessValue = 100;
                _applyAdjustments(imageProcessor);
              });
            },
            () {
              setState(() {
                _brightnessValue -= 10;
                if (_brightnessValue < -100) _brightnessValue = -100;
                _applyAdjustments(imageProcessor);
              });
            },
          ),
          _buildAdjustmentRow(
            context,
            'Saturation',
            Icons.spa,
            () {
              setState(() {
                _saturationValue += 0.1;
                if (_saturationValue > 2.0) _saturationValue = 2.0;
                _applyAdjustments(imageProcessor);
              });
            },
            () {
              setState(() {
                _saturationValue -= 0.1;
                if (_saturationValue < 0.0) _saturationValue = 0.0;
                _applyAdjustments(imageProcessor);
              });
            },
          ),
          _buildAdjustmentRow(
            context,
            'Teinte',
            Icons.color_lens,
            () {
              setState(() {
                _hueValue += 0.1;
                if (_hueValue > 1.0) _hueValue = 1.0;
                _applyAdjustments(imageProcessor);
              });
            },
            () {
              setState(() {
                _hueValue -= 0.1;
                if (_hueValue < -1.0) _hueValue = -1.0;
                _applyAdjustments(imageProcessor);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdjustmentRow(BuildContext context, String label, IconData icon,
      VoidCallback onIncrease, VoidCallback onDecrease) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove_circle_outline),
              onPressed: onDecrease,
              color: Colors.teal,
            ),
            Icon(icon, color: Colors.teal),
            IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: onIncrease,
              color: Colors.teal,
            ),
          ],
        ),
      ],
    );
  }
}

class FilterButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData icon;

  FilterButton({
    required this.onPressed,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: TextStyle(fontSize: 14),
      ),
    );
  }
}

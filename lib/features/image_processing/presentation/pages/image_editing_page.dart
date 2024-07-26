import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
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
      body: Consumer<ImageProcessorProvider>(
        builder: (context, imageProcessor, child) {
          final imageBytes = imageToUint8List(_showOriginal
              ? imageProcessor.originalImage
              : imageProcessor.processedImage);

          return imageProcessor.originalImage == null
              ? Center(child: Text('Aucune image sélectionnée.'))
              : Column(
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: imageBytes != null
                          ? Image.memory(
                              imageBytes,
                              width: 300,
                              height: 300,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 300,
                              height: 300,
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
                    SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Filtres',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
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
                                      imageProcessor
                                          .applyLaplacianEdgeDetection();
                                    });
                                  },
                                  label: 'Contours Laplacian',
                                  icon: Icons.grain,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Ajustements',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                            _buildSlider(
                              context,
                              label: 'Contraste',
                              value: _contrastValue,
                              min: 0.5,
                              max: 2.0,
                              divisions: 30,
                              onChanged: (value) {
                                setState(() {
                                  _contrastValue = value;
                                  imageProcessor.applyContrast(value);
                                });
                              },
                            ),
                            _buildSlider(
                              context,
                              label: 'Luminosité',
                              value: _brightnessValue.toDouble(),
                              min: -100,
                              max: 100,
                              divisions: 200,
                              onChanged: (value) {
                                setState(() {
                                  _brightnessValue = value.toInt();
                                  imageProcessor
                                      .applyBrightness(_brightnessValue);
                                });
                              },
                            ),
                            _buildSlider(
                              context,
                              label: 'Saturation',
                              value: _saturationValue,
                              min: 0.0,
                              max: 2.0,
                              divisions: 20,
                              onChanged: (value) {
                                setState(() {
                                  _saturationValue = value;
                                  imageProcessor.applySaturation(value);
                                });
                              },
                            ),
                            _buildSlider(
                              context,
                              label: 'Teinte',
                              value: _hueValue,
                              min: -1.0,
                              max: 1.0,
                              divisions: 20,
                              onChanged: (value) {
                                setState(() {
                                  _hueValue = value;
                                  imageProcessor.applyHue(value);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
        },
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

  Widget _buildSlider(
    BuildContext context, {
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: value.toStringAsFixed(1),
            onChanged: onChanged,
          ),
        ],
      ),
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
